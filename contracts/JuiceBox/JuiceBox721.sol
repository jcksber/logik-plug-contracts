// SPDX-License-Identifier: MIT
/*
 * JuiceBox721.sol
 *
 * Author: Jack Kasbeer
 * Created: October 27, 2021
 */

pragma solidity >=0.5.16 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "./JuiceBoxStorage.sol";
import "../KasbeerAccessControl.sol";
import "../LibPart.sol";


//@title Kasbeer Made Contract for an ERC721
//@author Jack Kasbeer (git:@jcksber, tw:@satoshigoat)
contract JuiceBox721 is ERC721, KasbeerAccessControl, JuiceBoxStorage {

	using Counters for Counters.Counter;
	using SafeMath for uint256;

	event JuiceBoxMinted(uint256 indexed tokenId);
	event JuiceBoxBurned(uint256 indexed tokenId);
	
	constructor(string memory temp_name, string memory temp_symbol) 
		ERC721(temp_name, temp_symbol)
	{
		// Add deployer (logik)
		addToSquad(msg.sender);
		addToWhitelist(msg.sender);
	}

	// -----------
	// RESTRICTORS
	// -----------

	modifier hashIndexInRange(uint8 idx)
	{
		require(0 <= idx && idx < NUM_ASSETS, "JuiceBox721: index OOB");
		_;
	}
	
	modifier onlyValidTokenId(uint256 tokenId)
	{
		require(1 <= tokenId && tokenId <= MAX_NUM_TOKENS, "JuiceBox721: tokenId OOB");
		_;
	}

	// ------
	// ERC721 
	// ------

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
    function mint(address to)
    	isSquad public virtual returns (uint256)
    {
    	_tokenIds.increment();

		uint256 newId = _tokenIds.current();
		_safeMint(to, newId);
		emit JuiceBoxMinted(newId);

		return newId;
    }

	//@dev Custom burn function - nothing special
	function burn(uint256 tokenId) 
		public virtual
	{
		require(isInSquad(msg.sender) || msg.sender == ownerOf(tokenId), 
			"JuiceBox721: not owner or in squad.");
		_burn(tokenId);
		emit JuiceBoxBurned(tokenId);
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

    //@dev Get the hash stored at `idx` 
	function getHashByIndex(uint8 idx) hashIndexInRange(idx) public view 
	  returns (string memory)
	{
		return boxHashes[idx];
	}

	//@dev Allows us to update the IPFS hash values (one at a time)
	function updateHash(uint8 idx, string memory str) 
		isSquad hashIndexInRange(idx) public
	{
		boxHashes[idx] = str;
	}

	//@dev Determine if '_assetHash' is one of the IPFS hashes in asset hashes
	function _hashExists(string memory assetHash) 
		internal view returns (bool) 
	{
		uint8 i;
		for (i = 0; i < NUM_ASSETS; i++) {
			if (_stringsEqual(assetHash, boxHashes[i])) {
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
		isSquad public
	{
		require(amount <= address(this).balance,
			"JuiceBox721: Insufficient funds to withdraw");
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
	function updateContractUri(string memory updatedContractUri) 
		isSquad public
	{
        contractUri = updatedContractUri;
    }
	
    // -----------------
    // SECONDARY MARKETS
	// -----------------

	//@dev Rarible Royalties V2
    function getRaribleV2Royalties(uint256 id) 
    	onlyValidTokenId(id) external view returns (LibPart.Part[] memory) 
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