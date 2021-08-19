// SPDX-License-Identifier: MIT
/*
 * KasbeerMade.sol
 *
 * Author: Jack Kasbeer
 * Created: August 19, 2021
 */

 pragma solidity 0.7.3;

 contract KasbeerMade {
 	
	constructor() {}

 	/*** HELPER FUNCTIONS ***/

	// Determine if two strings are equal using the length + hash method
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

	// Ownership
	modifier isMe()
	{
		// Can easily add a few other addresses
		require(msg.sender == 0xEAb4Aea5cD7376C04923236c504e7e91362566D1, 
			"Plug: Caller not permitted.");
		_;
	}
 }

