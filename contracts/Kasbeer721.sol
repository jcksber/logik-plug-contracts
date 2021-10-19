// SPDX-License-Identifier: MIT
/*
 * Kasbeer721.sol
 *
 * Author: Jack Kasbeer
 * Created: August 21, 2021
 */

pragma solidity >=0.5.16 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "./KasbeerStorage.sol";
import "./KasbeerAccessControl.sol";

//@title Kasbeer Made Contract for an ERC721
//@author Jack Kasbeer (git:@jcksber, tw:@satoshigoat)
contract Kasbeer721 is ERC721, KasbeerAccessControl, KasbeerStorage {

	using Counters for Counters.Counter;

	//@dev Emitted when a token is minted
	event ERC721Minted(uint256 indexed tokenId);

	//@dev Emitted when a token is burned
	event ERC721Burned(uint256 indexed tokenId);

	//@dev Emitted when an ipfs hash is updated
	event HashUpdated(uint8 indexed group, uint8 indexed hashNum, string indexed newHash);
	
	//@dev You'll want to alter the name of the token if you inherit from this 
	constructor(string memory _temp_name, string memory _temp_symbol) 
		ERC721(_temp_name, _temp_symbol)
	{
		// Add my personal dev address
		addToSquad(0xEAb4Aea5cD7376C04923236c504e7e91362566D1);
	}


	/*** TOKEN URI FUNCTIONS (HASH MANIPULATION) ************************************************/

	//@dev All of the asset's will be pinned to IPFS
	function _baseURI() 
		internal view virtual override 
		returns (string memory)
	{
		return "https://ipfs.io/ipfs/";//NOTE: per OpenSea recommendations
	}

	//@dev Determine if '_assetHash' is one of the IPFS hashes in asset hashes
	function _hashExists(string memory _assetHash) 
		internal view 
		returns (bool) 
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

	//@dev Allows us to update the IPFS hash values (one at a time)
	// group refers to normal (0), chicago (1), or st louis (2)
	function updateHash(uint8 group, uint8 hashNum, string memory str)
		isSquad 
		public
	{
		require(0 <= hashNum && hashNum < NUM_ASSETS, "Kasbeer721: hashNum OOB");
		require(0 <= group && group <= 2, "Kasbeer721: group OOB");

		if (group == 0) {
			normHashes[hashNum] = str;
		} else if (group == 1) {
			chiHashes[hashNum] = str;
		} else {
			stlHashes[hashNum] = str;
		}
		emit HashUpdated(group, hashNum, str);
	}

	//@dev Get the hash stored at `idx` for `group` 
	// 0:nomad, 1:chicago, 2:st.louis
	function getHashByIndex(uint8 group, uint256 idx)
		public view 
		returns (string memory)
	{
		require(0 <= idx && idx < NUM_ASSETS, "Kasbeer721: index OOB");
		require(0 <= group && group <= 2, "Kasbeer721: group OOB");

		if (group == 0) {
			return normHashes[idx];
		} else if (group == 1) {
			return chiHashes[idx];
		} else {
			return stlHashes[idx];
		}
	}


	/*** MINT & BURN ****************************************************************************/

	//@dev Allows owners to mint for free
    function mint721(address _to) 
    	isSquad 
    	public virtual 
    	returns (uint256)
    {
    	_tokenIds.increment();

		uint256 newId = _tokenIds.current();
		_safeMint(_to, newId);
		emit ERC721Minted(newId);

		return newId;
    }

	//@dev Custom burn function - nothing special
	function burn721(uint256 tokenId) 
		public virtual
	{
		require(isInSquad(msg.sender) || msg.sender == ownerOf(tokenId), 
			"Kasbeer721: not owner or in squad.");
		_burn(tokenId);
		emit ERC721Burned(tokenId);
	}

	//@dev Returns the current token id (number minted so far)
	function getCurrentId() 
		public view 
		returns (uint256)
	{
		return _tokenIds.current();
	}


	/*** TRANSFER FUNCTIONS *********************************************************************/

	//@dev This is here as a reminder to override for custom transfer functionality
	function _beforeTokenTransfer(address from, address to, uint256 tokenId) 
		internal virtual override 
	{ 
		super._beforeTokenTransfer(from, to, tokenId); 
	}

	//@dev Allows us to withdraw funds collected
	function withdraw(address payable wallet, uint256 amount)
		onlyOwner
		public
	{
		require(amount <= address(this).balance,"Kasbeer721: Insufficient funds to withdraw");
		wallet.transfer(amount);
	}


	/*** HELPER FUNCTIONS ***********************************************************************/

	//@dev Destroy contract and reclaim leftover funds
    function kill() 
    	onlyOwner
    	public 
    {
        selfdestruct(payable(msg.sender));
    }

	function supportsInterface(bytes4 interfaceId) 
		public view virtual override 
		returns (bool)
	{
		return super.supportsInterface(interfaceId);
	}

	//@dev Determine if two strings are equal using the length + hash method
	function _stringsEqual(string memory a, string memory b) 
		internal pure 
		returns (bool)
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
