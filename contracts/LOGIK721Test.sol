// SPDX-License-Identifier: MIT
/*
 * LOGIKCollectible.sol
 *
 * Author: Jack Kasbeer
 * Created: May 19, 2021
 *
 * Description: An ERC-1155 token that will be some generic 
 * collectible to appreciate LOGIK. Very basic token.
 *
 * Price: ~0.3 ETH
 *
 * TestNet Address: 0x4af7B9D835415d9c777589D8907b0e44fA356214
 *
 * NOTE(ERC1155): minting 100 cost ~0.0047 ETH
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

	// BROKEN FUNCTION
	// Looping doesn't work here bc the token ID needs to be returned
	function mintCollectibles721(address recipient, string memory tokenURI) 
		public onlyOwner
	{	
		for (uint i = 0; i < NUM_COLLECTIBLES; i++) {
			_tokenIds.increment(); //for future collectibles

			uint256 newCollectibleId = _tokenIds.current();
			_mint(recipient, newCollectibleId);
			_setTokenURI(newCollectibleId, tokenURI);
		}
	}
}
