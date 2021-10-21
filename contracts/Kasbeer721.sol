// SPDX-License-Identifier: MIT
/*
 * Kasbeer721.sol
 *
 * Author: Jack Kasbeer
 * Created: August 21, 2021
 */

pragma solidity >=0.5.16 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "./KasbeerStorage.sol";
import "./KasbeerAccessControl.sol";
import "./LibPart.sol";


//@title Kasbeer Made Contract for an ERC721
//@author Jack Kasbeer (git:@jcksber, tw:@satoshigoat)
contract Kasbeer721 is ERC721, KasbeerAccessControl, KasbeerStorage {

	using Counters for Counters.Counter;
	using SafeMath for uint256;

	event ERC721Minted(uint256 indexed tokenId);
	event ERC721Burned(uint256 indexed tokenId);
	
	constructor(string memory _temp_name, string memory _temp_symbol) 
		ERC721(_temp_name, _temp_symbol)
	{
		// Add my personal dev address
		addToSquad(0xEAb4Aea5cD7376C04923236c504e7e91362566D1);
	}

	// -----------
	// RESTRICTORS
	// -----------

	modifier hashIndexInRange(uint8 idx)
	{
		require(0 <= idx && idx < NUM_ASSETS, "Kasbeer721: index OOB");
		_;
	}
	
	modifier groupInRange(uint8 group)
	{
		require(0 <= group && group <= 2, "Kasbeer721: group OOB");
		_;// 0:nomad, 1:chicago, 2:st.louis
	}

	modifier onlyValidTokenId(uint256 tokenId)
	{
		require(1 <= tokenId <= MAX_NUM_PLUGS, "KasbeerMade721: tokenId OOB");
	}

	// ----------------
	// ERC721 OVERRIDES
	// ----------------

	//@dev All of the asset's will be pinned to IPFS
	function _baseURI() 
		internal view virtual override returns (string memory)
	{
		return "ipfs://";//NOTE: per OpenSea recommendations
	}

	//@dev This is here as a reminder to override for custom transfer functionality
	function _beforeTokenTransfer(address from, address to, uint256 tokenId) 
		internal virtual override 
	{ 
		super._beforeTokenTransfer(from, to, tokenId); 
	}

	//@dev Allows owners to mint for free
    function mint(address _to) 
    	isSquad public virtual override returns (uint256)
    {
    	_tokenIds.increment();

		uint256 newId = _tokenIds.current();
		_safeMint(_to, newId);
		emit ERC721Minted(newId);

		return newId;
    }

	//@dev Custom burn function - nothing special
	function burn(uint256 tokenId) 
		public virtual override
	{
		require(isInSquad(msg.sender) || msg.sender == ownerOf(tokenId), 
			"Kasbeer721: not owner or in squad.");
		_burn(tokenId);
		emit ERC721Burned(tokenId);
	}

	function supportsInterface(bytes4 interfaceId) 
		public view virtual override returns (bool)
	{
		return interfaceId == _INTERFACE_ID_ERC165
        || interfaceId == _INTERFACE_ID_ROYALTIES
        || interfaceId == _INTERFACE_ID_ERC721
        || interfaceId == _INTERFACE_ID_ERC721_METADATA
        || interfaceId == _INTERFACE_ID_ERC721_ENUMERABLE
        || interfaceId == _INTERFACE_ID_EIP2981
        || super.supportsInterface(interfaceId);
	}

    // ----------------------
    // IPFS HASH MANIPULATION
    // ----------------------

    //@dev Get the hash stored at `idx` for `group` 
	function getHashByIndex(
		uint8 group, 
		uint8 idx
	) groupInRange(group) hashIndexInRange(idx) public view 
	  returns (string memory)
	{
		if (group == 0) {
			return normHashes[idx];
		} else if (group == 1) {
			return chiHashes[idx];
		} else {
			return stlHashes[idx];
		}
	}

	//@dev Allows us to update the IPFS hash values (one at a time)
	function updateHash(
		uint8 group, 
		uint8 hashNum, 
		string memory str
	) isSquad groupInRange(group) hashIndexInRange(hashNum) public
	{
		if (group == 0) {
			normHashes[hashNum] = str;
		} else if (group == 1) {
			chiHashes[hashNum] = str;
		} else {
			stlHashes[hashNum] = str;
		}
	}

	//@dev Determine if '_assetHash' is one of the IPFS hashes in asset hashes
	function _hashExists(string memory _assetHash) 
		internal view returns (bool) 
	{
		uint8 i;
		for (i = 0; i < NUM_ASSETS; i++) {
			if (_stringsEqual(_assetHash, normHashes[i]) || 
				_stringsEqual(_assetHash, chiHashes[i]) ||
				_stringsEqual(_assetHash, stlHashes[i])) {
				return true;
			}
		}
		return false;
	}

	// ------
	// USEFUL
	// ------

	//@dev Returns the current token id (number minted so far)
	function getCurrentId() 
		public view returns (uint256)
	{
		return _tokenIds.current();
	}

	//@dev Allows us to withdraw funds collected
	function withdraw(address payable wallet, uint256 amount)
		onlyOwner public
	{
		require(amount <= address(this).balance,"Kasbeer721: Insufficient funds to withdraw");
		wallet.transfer(amount);
	}

	//@dev Destroy contract and reclaim leftover funds
    function kill() 
    	onlyOwner public 
    {
        selfdestruct(payable(msg.sender));
    }

    // ------------
	// CONTRACT URI
	// ------------

	//@dev Controls the contract-level metadata to include things like royalties
	function contractURI()
		public view returns(string memory)
	{
		return contractUri;
	}

	//@dev Ability to change the contract URI
	function updateContractUri(string memory _updatedContractUri) 
		isSquad public
	{
        contractUri = _updatedContractUri;
    }
	
    // -----------------
    // SECONDARY MARKETS
	// -----------------

	//@dev Rarible Royalties V2
    function getRaribleV2Royalties(uint256 id) 
    	onlyValidTokenId(id) external view override returns (LibPart.Part[] memory) 
    {
        LibPart.Part[] memory royalties = new LibPart.Part[](1);
        royalties[0] = LibPart.Part({
            account: payable(payoutAddress),
            value: uint96(royaltyFeeBps)
        });

        return royalties;
    }

    //@dev EIP-2981
    function royaltyInfo(uint256 tokenId, uint256 salePrice) external view onlyValidTokenId(tokenId) returns (address receiver, uint256 amount) {
        uint256 ourCut = SafeMath.div(SafeMath.mul(salePrice, royaltyFeeBps), 10000);
        return (payoutAddress, ourCut);
    }

    // -------
    // HELPERS
    // -------

	//@dev Determine if two strings are equal using the length + hash method
	function _stringsEqual(string memory a, string memory b) 
		internal pure returns (bool)
	{
		bytes memory A = bytes(a);
		bytes memory B = bytes(b);

		if (A.length != B.length) {
			return false;
		} else {
			return keccak256(A) == keccak256(B);
		}
	}
}
