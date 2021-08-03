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
 *  - Asset cycle: 1. 0 months: 0% juice
 *				   2. 2 months: 20% juice
 *				   3. 4 months: 40% juice
 				   4. 6 months: 60% juice
 				   5. 8 months: 80% juice
 				   6. 10 months: 100% juice / silver
 				   7. 12 months: 100% juice / gold
 *
 */

pragma solidity ^0.7.3;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Plug is ERC721, Ownable {
	using Counters for Counters.Counter;
	Counters.Counter private _tokenIds;

	uint constant NUM_ASSETS = 7;
	uint constant MAX_NUM_TRANSFERS = 1000;

	uint16 private _numTransfers = 0; //16 bits should be plenty
	uint8 private _currentHashIdx = 0;
	uint private _lastTransferTime; //represented in UTC

	string[NUM_ASSETS] = ["hash0",
						  "hash1",
						  "hash2",
						  "hash3",
						  "hash4",
						  "hash5",
						  "hash6"];

	// Initialize _lastTransferTime & create token
	constructor() ERC721("https://logik-genesis-api.herokuapp.com/api/other/giffy.json") 
	{
		_lastTransferTime = block.timestamp;
	}

	function _baseURI() internal view virtual override returns (string memory)
	{
		return "https://ipfs.io/ipfs/";
	}

	function tokenHash(uint256 tokenId) internal returns (string memory)
	{
		require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");

		// logic to handle assigning the URI based on days passed
		// since _lastTransferTime
	}

	// Overriding this function in order to include logic for changing
	// the URI based on days passed since transfer of ownership
	function tokenURI(uint256 tokenId) public view virtual override returns (string memory) 
	{	
		require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");

		string memory baseURI = _baseURI();
		string memory hash = tokenHash(tokenId);
		
		return string(abi.encodePacked(baseURI, hash));
	}

	// override _safeTransfer to include logic to reset _lastTransferTime &
	// MAYBE burn the token if it's been transferred more than X times

	// Mint a single Plug
	function mintPlug(address recipient) public onlyOwner returns (uint256)
	{
		_tokenIds.increment();

		uint256 newId = _tokenIds.current();
		_safeMint(recipient, newId);

		return newId;
	}

	// Gives us the ability to determine the addresses of the owners
	// for each of the Plug levels (for airdrops & benefits)
	function listLevelOwners(string memory assetHash) public returns (string[])
	{
		// loop through the global owner list, and call tokenHash,
		// if this hash matches assetHash, add it to an array that 
		// we will return 
	}

}

