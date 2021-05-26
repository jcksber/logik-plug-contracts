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
 */

pragma solidity ^0.7.3;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
//import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

// need a mapping from addresses to account balances

contract LOGIKCollectible is ERC1155, Ownable {
	uint256 public constant NUM_COLLECTIBLES = 1000;

	constructor() public ERC1155("https://logik-genesis-api.herokuapp.com/api/other/collectible.json") {
		_mint(msg.sender, 0, NUM_COLLECTIBLES, ""); //1000 with id=0
	}
}





