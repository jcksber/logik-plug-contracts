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

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
contract LOGIKCollectible is ERC1155, Ownable {
	uint256 public constant NUM_COLLECTIBLES = 100;

	constructor() ERC1155("https://logik-genesis-api.herokuapp.com/api/other/collectible.json")
	{
		uint256[] memory ids = new uint256[](NUM_COLLECTIBLES);
		uint256[] memory amounts = new uint256[](NUM_COLLECTIBLES);
		
		for (uint i = 0; i < NUM_COLLECTIBLES; i++) { 
			ids[i] = i;
			amounts[i] = 1;
		}

		_mintBatch(msg.sender, ids, amounts, "");
	}

	// function mintCollectible(address recipient, string memory tokenURI) 
	// 	onlyOwner public
	// {
		

	// 	//_mint(msg.sender, 0, NUM_COLLECTIBLES, ""); //1000 with id=0
	// }
}





