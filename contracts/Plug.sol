// SPDX-License-Identifier: MIT
/*
 * Plug.sol
 *
 * Author: Jack Kasbeer
 * Created: August 3, 2021
 *
 * Price: ~0.35 ETH
 *
 * Description: An ERC-721 token that will change based on (1) time held by a single owner and
 * 				(2) trades between owners; the different versions give you access to airdrops.
 *
 *  - As long as the owner remains the same, every 60 days, the asset will acquire more "juice" 
 * 	  not only updating the asset, but allowing the owner to receive more airdrops from other 
 *    artists.  This means after a year, the final asset (and most valuable) will now be in the 
 *    owner's wallet (naturally each time, the previous asset is replaced).
 *  - If the NFT changes owners, the initial/day 0 asset is now what will be seen by the owner,
 *    and they'll have to wait a full year to achieve "final asset status" (gold)
 *  - Asset cycle: 1. 0 months (< 60 days): 0% juice
 *				   2. 2 months (60 days): 20% juice
 *				   3. 4 months (120 days): 40% juice
 *				   4. 6 months (180 days): 60% juice
 *				   5. 8 months (240 days): 80% juice
 *				   6. 10 months (300 days): 100% juice / silver
 *				   7. 12 months (360 days): 100% juice / gold
 */

pragma solidity ^0.7.3;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
// import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";

contract Plug is ERC721, Ownable {
	using Counters for Counters.Counter;
	Counters.Counter private _tokenIds;

	uint constant NUM_ASSETS = 7;
	// Production hashes
	string constant HASH_0 = "Qmf17yfaQsBmZkyVfc3JfiSqGifN5VQaKJmTGdQnAuAkmE"; //1% Plug
	string constant HASH_1 = "QmemZy6Ysr4tafv6F7Xm613ACgpr9LscrGNCqh67dcV8fS";
	string constant HASH_2 = "QmXdnXnHKQ4piXKv1aRkdy9BhuxQWBFcZjR6RcyHXhq6N2";
	string constant HASH_3 = "Qmd8HyLnhvZbAVNqPMcah6bYHLVcc9Aumhohpr7azcuTP4";
	string constant HASH_4 = "QmbKYkSBuencis49GjKqCc4jPWyCRpHsmA1JtqWBoiLojf";
	string constant HASH_5 = "QmShxEMhMSanqYLV2dhweivjyrVbdVLDpP5QhJ7cmbCwEK";
	string constant HASH_6 = "QmYg1u1b39nWbv4TcsxU4Jgrv8qwsDzUiuShmi1RiU5t98"; //100% Plug
	// Our list of IPFS hashes for each of the 7 Plugs (varying juice levels)
	string [NUM_ASSETS] _assetHashes = [HASH_0, HASH_1, HASH_2, HASH_3, HASH_4, HASH_5, HASH_6];

	// Keep track of the "last transfer time" (o.t.w. mint time) for each token ID
	mapping(uint256 => uint) private _lastTransferTimes;

	// Create Plug
	constructor() ERC721("LOGIK: Plug", "") 
	{
		// nothing to be done here i don't beleive
	}

	// Override 'tokenURI' to account for asset/hash cycling
	function tokenURI(uint256 tokenId) public view virtual override returns (string memory) 
	{	
		require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");

		string memory baseURI = _baseURI();
		string memory hash = _tokenHash(tokenId);
		
		return string(abi.encodePacked(baseURI, hash));
	}

	// Override safeTransferFrom to update the last transfer time for 'tokenId'
	function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override 
	{
		/*
		global: uint constant MAX_NUM_TRANSFERS = 1000;
				uint16 private _numTransfers = 0; //16 bits should be plenty
		if we want to add some logic to burn this Plug if it's been transferred too many
		times, this is probably the place to do it... e.g.

			_numTransfers++;
			if (_numTransfers >= MAX_NUM_TRANSFERS) {
				_burn(tokenId); //CANNOT USE THIS FUNCTION,
				return;			//NEED ERC721BURNABLE.SOL
			}
		*/
		_lastTransferTimes[tokenId] = block.timestamp;
		safeTransferFrom(from, to, tokenId, "");
	}

	// Mint a single Plug
	function mintPlug(address recipient) public onlyOwner returns (uint256)
	{
		_tokenIds.increment();

		uint256 newId = _tokenIds.current();
		_safeMint(recipient, newId);
		// Add this to our mapping of "last transfer times"
		_lastTransferTimes[newId] = block.timestamp;

		return newId;
	}

	// Burn a single Plug (destroy forever)
	function burn(uint256 tokenId) public virtual {
		require(_isApprovedOrOwner(_msgSender(), tokenId), "Burnable: caller is not approved to burn");
		_burn(tokenId);//don't actually know if this works yet
	}

	// List the owners for a certain level (determined by assetHash)
	// We'll need this for airdrops and benefits
	function listLevelOwners(string memory assetHash) public view returns (address[] memory)
	{
		require(_hashExists(assetHash), "ERC721Metadata: IPFS hash nonexistent");

		address[] memory owners;
		uint tokenId;
		uint lastTokenId = _tokenIds.current();
		uint counter = 0; //keeps track of where we are in 'owners'

		// Go thru list of created token id's (existing Plugs) so far
		for (tokenId = 1; tokenId <= lastTokenId; tokenId++) {

			// Find the IPFS hash associated with this token ID
			string memory hash = _tokenHash(tokenId);

			// If this is equal to the hash we're looking for (assetHash)
			// then determine the owner of the token and add it to our list
			if (_stringsEqual(hash, assetHash)) {
				address owner = ownerOf(tokenId);
				owners[counter] = owner;
				counter++;
			}
		}

		return owners;
	}
	
	// Function to help with testing: number of hours since transfer/mint
	function howManyHoursPassed(uint256 tokenId) public returns (uint8) 
	{
		return uint8((block.timestamp - _lastTransferTimes[tokenId]) / 1 hours);
	}

	// Function to help with testing: number of days since transfer/mint
	function howManyDaysPassed(uint256 tokenId) public returns (uint8) 
	{
		return uint8((block.timestamp - _lastTransferTimes[tokenId]) / 1 days);
	}


	// All of the asset's will be pinned to IPFS
	function _baseURI() internal view virtual returns (string memory)
	{
		return "https://ipfs.io/ipfs/";
	}

	// Based on the number of days that have passed since the last transfer of
	// ownership, this function returns the appropriate IPFS hash
	function _tokenHash(uint256 tokenId) internal view virtual returns (string memory)
	{
		require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");

		// PRODUCTION LOGIC ///////////////////////////////////////////////////////
		// Calculate days gone by for this particular token with 'tokenId'
		// uint daysPassed = (block.timestamp - _lastTransferTimes[tokenId]) / 1 days;
		// // The logic here is "reversed" for cleaner code
		// if (daysPassed >= 360) {
		// 	return HASH_6;
		// } else if (daysPassed >= 300) {
		// 	return HASH_5;
		// } else if (daysPassed >= 240) {
		// 	return HASH_4;
		// } else if (daysPassed >= 180) {
		// 	return HASH_3;
		// } else if (daysPassed >= 120) {
		// 	return HASH_2;
		// } else if (daysPassed >= 60) {
		// 	return HASH_1;
		// } else { //if 60 days haven't passed, the initial asset/Plug is returned
		// 	return HASH_0; 
		// }

		// TEST LOGIC /////////////////////////////////////////////////////////////
		// Calculate the number of hours that have passed for 'tokenId'
		uint hoursPassed = (block.timestamp - _lastTransferTimes[tokenId]) / 1 hours;
		// The logic here is "reversed" for cleaner code
		if (hoursPassed >= 12) {
			return HASH_6;
		} else if (hoursPassed >= 10) {
			return HASH_5;
		} else if (hoursPassed >= 8) {
			return HASH_4;
		} else if (hoursPassed >= 6) {
			return HASH_3;
		} else if (hoursPassed >= 4) {
			return HASH_2;
		} else if (hoursPassed >= 2) {
			return HASH_1;
		} else {
			return HASH_0; 
		}
	}

	// Determine if 'assetHash' is one of the IPFS hashes for Plug
	function _hashExists(string memory assetHash) internal pure returns (bool) 
	{
		return _stringsEqual(assetHash, HASH_0) || 
			   _stringsEqual(assetHash, HASH_1) ||
			   _stringsEqual(assetHash, HASH_2) ||
			   _stringsEqual(assetHash, HASH_3) ||
			   _stringsEqual(assetHash, HASH_4) ||
			   _stringsEqual(assetHash, HASH_5) ||
			   _stringsEqual(assetHash, HASH_6);
	}

	// Determine if two strings are equal using the length + hash method
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

