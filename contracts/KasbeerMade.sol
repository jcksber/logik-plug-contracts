// SPDX-License-Identifier: MIT
/*
 * KasbeerMade.sol
 *
 * Author: Jack Kasbeer
 * Created: August 19, 2021
 */

pragma solidity 0.7.3;

import "@openzeppelin/contracts/access/Ownable.sol";

//@title Kasbeer Made Contract
//@author Jack Kasbeer (@jcksber, @satoshigoat)
contract KasbeerMade is Ownable {
 	
 	// NOTE: This may be done incorrectly because I have that Gnosis Wallet
 	uint constant private NUM_OWNERS = 2;
 	address [NUM_OWNERS] private _squad = [0xEAb4Aea5cD7376C04923236c504e7e91362566D1,
 						  				   0x6b8C6E15818C74895c31A1C91390b3d42B336799];
	constructor() {}

	/*** Ownership ***/

	modifier isSquad()
	{
		// Can easily add a few other addresses
		require(isInSquad(msg.sender), "Plug: Caller not part of squad.");
		_;
	}

	// @dev Determine if address 'a' is an approved owner
	function isInSquad(address a) public view returns (bool) 
	{
		uint i;
		for (i = 0; i < NUM_OWNERS; i++) {
			if (a == _squad[i]) {
				return true;
			}
		}
		return false;
	}

	/*** Helpers ***/

	// @dev Determine if two strings are equal using the length + hash method
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
