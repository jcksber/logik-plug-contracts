// SPDX-License-Identifier: MIT
/*
 * LOGIKPassport.sol
 *
 * Author: Jack Kasbeer
 * Created: May 19, 2021
 *
 * Description: An ERC-1155 token that will represent Tier 1 Passport - 
 * it will be capable of "holding" LOGIKStamp NFT's.  It should in some ways
 * govern the circulation of LOGIKStamp's because they will be directly tethered
 * to a LOGIKPassport unless a holder wishes to distribute or burn them. DOUBLE CHECK!!!!!
 *
 * Price: ~8 ETH
 */

pragma solidity ^0.7.3;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
//import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

// need a mapping from addresses to account balances !!!!!!!!!!!!!

contract LOGIKPassport is ERC1155, Ownable {
	uint256 public constant NUM_PASSPORTS = 8;

	constructor() public ERC1155("https://logik-genesis-api.herokuapp.com/api/other/passport-cover.json") {
		_mint(msg.sender, 0, NUM_PASSPORTS, ""); //8 with id=0
		// initialize msg.sender's accounts balance to [1,1,1,1,1,1,1]
	}
}


