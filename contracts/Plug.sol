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
 * 				(2) trades between owners
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

contract Plug is ERC721, Ownable {
	using Counters for Counters.Counter;
	Counters.Counter private _tokenIds;

	uint constant NUM_ASSETS = 7;
	uint constant NUM_PLUGS = 10;
	uint constant MAX_NUM_TRANSFERS = 1000;

	uint16 private _numTransfers = 0; //16 bits should be plenty
	uint8 private _currentHashIdx = 0;
	uint private _lastTransferTime; //represented in UTC (seconds)

	string constant HASH_0 = "hash0"; //corresponds to 0% juice (initial Plug)
	string constant HASH_1 = "hash1";
	string constant HASH_2 = "hash2";
	string constant HASH_3 = "hash3";
	string constant HASH_4 = "hash4";
	string constant HASH_5 = "hash5";
	string constant HASH_6 = "hash6"; //corresponds to 100% juice gold Plug
	string[NUM_ASSETS] = [HASH_0, HASH_1, HASH_2, HASH_3, HASH_4, HASH_5, HASH_6];

	// Initialize _lastTransferTime & create token
	constructor() ERC721("https://logik-genesis-api.herokuapp.com/api/other/giffy.json") 
	{
		_lastTransferTime = block.timestamp;
	}

	// Based on the number of days that have passed since the last transfer of
	// ownership, this function returns the appropriate IPFS hash
	function tokenHash(uint256 tokenId) internal returns (string memory)
	{
		require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");

		// Calculate days gone by
		uint daysPassed = (block.timestamp - _lastTransferTime) / 1 days;

		// The logic here is "reversed" for cleaner code
		if (daysPassed >= 360) {
			return HASH_6;
		} else if (daysPassed >= 300) {
			return HASH_5;
		} else if (daysPassed >= 240) {
			return HASH_4;
		} else if (daysPassed >= 180) {
			return HASH_3;
		} else if (daysPassed >= 120) {
			return HASH_2;
		} else if (daysPassed >= 60) {
			return HASH_1;
		} else { //if 60 days haven't passed, the initial asset/Plug is returned
			return HASH_0; 
		}
	}

	// Override 'tokenURI' to account for asset/hash cycling
	function tokenURI(uint256 tokenId) public view virtual override returns (string memory) 
	{	
		require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");

		string memory baseURI = _baseURI();
		string memory hash = tokenHash(tokenId);
		
		return string(abi.encodePacked(baseURI, hash));
	}

	// override safeTransferFrom to update _lastTransferTime 
	function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override 
	{
		_lastTransferTime = block.timestamp;
		safeTransferFrom(from, to, tokenId, "");
	}


	// Mint a single Plug
	function mintPlug(address recipient) public onlyOwner returns (uint256)
	{
		_tokenIds.increment();

		// Each new Plug will have an id = (previous Plug + 1)
		uint256 newId = _tokenIds.current();
		_safeMint(recipient, newId);

		return newId;
	}

	// List the owners for a certain level (determined by assetHash)
	// We'll need this for airdrops and benefits
	function listLevelOwners(string memory assetHash) public returns (address[])
	{
		require(_hashExists(assetHash), "ERC721Metadata: IPFS hash nonexistent");

		address[] owners;
		uint i;//double check this logic but i think the id's start at 1 (not 0)
		for (i = 1; i <= NUM_PLUGS; i++) {
			hash = tokenHash(i);
			if (hash == assetHash) {
				owner = ownerOf(i);
				owners.push(owner);
			}
		}

		return owners;
	}

	// All of the asset's will be pinned to IPFS
	function _baseURI() internal view virtual override returns (string memory)
	{
		return "https://ipfs.io/ipfs/";
	}

	// Determine if 'assetHash' is one of the ipfs hashes for Plug
	function _hashExists(string memory assetHash) internal returns (bool) 
	{
		return assetHash == HASH_0 || 
			   assetHash == HASH_1 ||
			   assetHash == HASH_2 ||
			   assetHash == HASH_3 ||
			   assetHash == HASH_4 ||
			   assetHash == HASH_5 ||
			   assetHash == HASH_6;
	}
}



















