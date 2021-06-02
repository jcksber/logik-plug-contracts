// SPDX-License-Identifier: MIT
/*
 * Test file for ERC721 to determine mint costs
 * 
 * Minting 1 cost ~0.0003 ETH
 */

pragma solidity ^0.7.3;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract BLMTest is ERC721, Ownable {
	using Counters for Counters.Counter;
	Counters.Counter private _tokenIds;
	uint private _creationUnix;
	//uint constant NUM_DAYS_IN_CYCLE = 10;
	string[2] _assetURIs = ["https://gateway.pinata.cloud/ipfs/QmQr5GPfbboVMkntaBYYSMoSzR29bZMGPNefon4GiCEZzm", "https://gateway.pinata.cloud/ipfs/QmNawKGNQxweTEzKADMoqXbAsyCDYR3KWbsCstrazKbwFC"];
	
	constructor() ERC721("BLMTest", "BLM0") {
		// Permanently store the creation date of the contract
		_creationUnix = block.timestamp;
	}

	// Override the tokenURI function to return a different URI depending
	// on how many days its been since creation
	function tokenURI(uint256 tokenId)
		public
		view
		virtual
		override
		returns (string memory)
	{
		require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");

		uint todayUnix = block.timestamp;
		uint8 hourNow = uint8((todayUnix / 60 / 60) % 24);
		uint256 daysPassed = 0;

		// Determine the current day & time to compute the difference from creation
		/////// FOR LOGIK'S 'EVERY 10 DAYS' ////////////
		// Unix epoch - get num days passed
		daysPassed = (todayUnix - _creationUnix) / 60 / 60 / 24;
		// uint idx;
		// idx = daysPassed % NUM_DAYS_IN_CYCLE;
		///////////////////////////////////////////////

		///// TEST -  every other hour //////////////////
		if (hourNow % 2 == 0) {
			return _assetURIs[0];
		} else {
			return _assetURIs[1];
		}
		//////////////////////////////////////////////
	}


	// This works just fine, but it can only mint a single token at a time
	function mintBLMTest(address recipient, string memory uri) 
		public onlyOwner
		returns (uint256)
	{	
		
		_tokenIds.increment(); //for future collectibles

		uint256 newCollectibleId = _tokenIds.current();
		_safeMint(recipient, newCollectibleId);
		_setTokenURI(newCollectibleId, uri);

		return newCollectibleId;
	}
}