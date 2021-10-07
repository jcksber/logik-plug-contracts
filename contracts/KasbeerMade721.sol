// SPDX-License-Identifier: MIT
/*
 * KasbeerMade721.sol
 *
 * Author: Jack Kasbeer
 * Created: August 21, 2021
 */

pragma solidity >=0.5.16 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./KasbeerStorage.sol";

//@title Kasbeer Made Contract for an ERC721
//@author Jack Kasbeer (@jcksber, @satoshigoat)
contract KasbeerMade721 is ERC721, Ownable, KasbeerStorage {

	using Counters for Counters.Counter;
	
	//@dev You'll want to alter the name of the token if you inherit from this 
	constructor(string memory _temp_name, string memory _temp_symbol) 
		ERC721(_temp_name, _temp_symbol)
	{
		// Add my personal dev address
		address me = 0xEAb4Aea5cD7376C04923236c504e7e91362566D1;
		addToSquad(me);
	}


	/*** TOKEN URI FUNCTIONS (HASH MANIPULATION) ***/

	//@dev Override 'tokenURI' to account for asset/hash cycling
	function tokenURI(uint256 tokenId) public view virtual override returns (string memory) 
	{	
		require(_exists(tokenId), 
			"KasbeerMade721 (ERC721Metadata): URI query for nonexistent token");

		string memory baseURI = _baseURI();
		string memory hash = _tokenHash(tokenId);
		
		return string(abi.encodePacked(baseURI, hash));
	}

	//@dev All of the asset's will be pinned to IPFS
	function _baseURI() internal view virtual override returns (string memory)
	{
		return "https://ipfs.io/ipfs/";
	}

	//@dev This function should return an ipfs hash that leads to a json file
	// e.g. QmSJQmBV5crGcmq54WUB22SRw9SGsp1YSaxfenQEbZ5qTD
	function _tokenHash(uint256 tokenId) internal virtual view returns (string memory)
	{
		require(_exists(tokenId), 
			"KasbeerMade721 (ERC721Metadata): URI query for nonexistent token");

		return "";
	}

	//@dev Determine if '_assetHash' is one of the IPFS hashes in assetHashes
	function _hashExists(string memory _assetHash) internal view returns (bool) 
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
	function updateHash(uint8 group, uint8 _hash_num, string memory _str) public isSquad 
	{
		require(0 <= _hash_num && _hash_num < NUM_ASSETS, 
			"KasbeerMade721: _hash_num out of bounds");
		require(0 <= group && group <= 2, "KasbeerMade721: group must be 0, 1, or 2");

		if (group == 0) {
			normHashes[_hash_num] = _str;
		} else if (group == 1) {
			chiHashes[_hash_num] = _str;
		} else {
			stlHashes[_hash_num] = _str;
		}
		emit HashUpdated(group, _str);
	}

	//@dev Get the hash stored at idx for group
	function getHashByIndex(uint8 group, uint256 idx) public view returns (string memory)
	{
		require(0 <= idx && idx < NUM_ASSETS, 
			"KasbeerMade721: index out of bounds");
		require(0 <= group && group <= 2, "KasbeerMade721: group must be 0, 1, or 2");

		if (group == 0) {
			return normHashes[idx];
		} else if (group == 1) {
			return chiHashes[idx];
		} else {
			return stlHashes[idx];
		}
	}


	/*** MINT & BURN ***/

	//@dev Custom mint function - nothing special 
	function mint721(address recipient) public virtual onlyOwner returns (uint256)
	{
		_tokenIds.increment();

		uint256 newId = _tokenIds.current();
		_safeMint(recipient, newId);

		emit ERC721Minted(newId);

		return newId;
	}

	//@dev Custom burn function - nothing special
	function burn721(uint256 tokenId) public virtual isSquad
	{
		_burn(tokenId);
		emit ERC721Burned(tokenId);
	}


	/*** OWNERSHIP ***/

	//@dev Custom "approved" modifier because I don't like that language
	modifier isSquad()
	{
		require(isInSquad(msg.sender), "KasbeerMade721: Caller not part of squad.");
		_;
	}

	//@dev Determine if address 'a' is an approved owner
	function isInSquad(address a) public view returns (bool) 
	{
		return _squad[a];
	}

	//@dev Add someone to the squad
	function addToSquad(address a) public onlyOwner
	{
		require(!isInSquad(a), "KasbeerMade721: Address already in squad.");

		_squad[a] = true;
		emit SquadMemberAdded(a);
	}

	//@dev Remove someone from the squad
	function removeFromSquad(address a) public onlyOwner
	{
		require(isInSquad(a), "KasbeerMade721: Address already not in squad.");

		_squad[a] = false;
		emit SquadMemberRemoved(a);
	}


	/*** TRANSFER FUNCTIONS ***/

	//@dev This is here as a reminder to override for custom transfer functionality
	function _beforeTokenTransfer(
		address from, 
		address to, 
		uint256 tokenId
	) internal virtual override {}
	

	/*** HELPER FUNCTIONS ***/

	//@dev This function doesn't work, not exactly sure why
	function kill() public onlyOwner
	{
		selfdestruct(payable(owner()));
	}

	//@dev Returns the most recently minted token id 
	function getCurrentTokenId() public view returns (uint256)
	{
		return _tokenIds.current();
	}

	//@dev Determine if a token exists 
	function tokenExists(uint256 tokenId) public view returns (bool)
	{
		return _exists(tokenId);
	}

	//@dev Determine if two strings are equal using the length + hash method
	function _stringsEqual(string memory a, string memory b) internal pure returns (bool)
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
