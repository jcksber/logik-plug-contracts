// SPDX-License-Identifier: MIT
/*
 * LOGIKGif.sol
 *
 * Author: Jack Kasbeer
 * Created: May 19, 2021
 *
 * Description: An ERC-1155 token that will simply be a .gif animation
 * made by logic and the his team. Very basic token.
 *
 * Price: ~0.8 ETH
 */

pragma solidity ^0.7.3;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract LOGIKGif is ERC1155, Ownable {
	uint256 public constant NUM_GIFFYS = 100;

	constructor() ERC1155("https://logik-genesis-api.herokuapp.com/api/other/giffy.json") {
		_mint(msg.sender, 0, NUM_GIFFYS, ""); //100 with id=0
	}
}





