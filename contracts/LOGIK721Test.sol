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

contract LOGIK721Test is ERC721, Ownable {
	using Counters for Counters.Counter;
	Counters.Counter private _tokenIds;
	uint256 public constant NUM_COLLECTIBLES = 10;

	constructor() ERC721("LOGIK721Test", "LGK7211") {}

	// This works just fine, but it can only mint a single token at a time
	function mintCollectible721(address recipient, string memory tokenURI) 
		public onlyOwner
		returns (uint256)
	{	
		
		_tokenIds.increment(); //for future collectibles

		uint256 newCollectibleId = _tokenIds.current();
		_mint(recipient, newCollectibleId);
		_setTokenURI(newCollectibleId, tokenURI);

		return newCollectibleId;
	}
}
