// SPDX-License-Identifier: MIT
/*
 * KasbeerMade.sol
 *
 * Author: Jack Kasbeer
 * Created: August 19, 2021
 */

pragma solidity ^0.7.3;

import "@openzeppelin/contracts/utils/Counters.sol";

//@title The Plug storage contract
//@author Jack Kasbeer (@jcksber, @satoshigoat)
contract PlugStorage {

	// @dev These take care of token id incrementing
	using Counters for Counters.Counter;
	Counters.Counter internal _tokenIds;

	// @dev Important numbers - CANNOT BE CHANGED
	uint constant NUM_ASSETS = 8;
	uint constant MAX_NUM_PLUGS = 88;

	// @dev Production hashes
	string internal HASH_0 = "QmeyKF86ke66i339GAbHrtiG5DHchqo7oRLb5ky419bhG4"; //1% Plug
	string internal HASH_1 = "QmTe7qzmMAV7NMGGvaqRcnaoFUoAYdcKz1cyZz4Yd8vBNV";
	string internal HASH_2 = "QmXrJgAJCcmh38tXCBBetcXx3Wxrctqsg6ve8J76FDorkF";
	string internal HASH_3 = "Qmbborkd6TyXofhWsFD9c2H6PzYii1VNkW7GjqT99kon6t";
	string internal HASH_4 = "QmUwgMPZKYQJ7B7C7aV3AUnA3hqBxrEFKpNKUGYuh4YBf4";
	string internal HASH_5 = "QmYSa8bVxwS8tQ4fRtaqZjucEVpQJNDHg2TuT4P12aqchX";
	string internal HASH_6 = "QmeJPegPQLG3tfvmzVueWtbAr1Ww5PZ6b2ZFwrht71xTNx"; //100% Plug
	string internal HASH_7 = "QmSsFEPJeqMeJZ5RcPekPCYX4JRbhMs1mdYKrzDw6DXGqT"; //grandfather Plug

	// @dev Our list of IPFS hashes for each of the 8 Plugs (varying juice levels)
	string [NUM_ASSETS] assetHashes = [HASH_0, HASH_1, 
									   HASH_2, HASH_3, 
									   HASH_4, HASH_5, 
									   HASH_6, HASH_7];

	// @dev Keep track of the birthday (mint/last transfer) for each token ID
	mapping(uint256 => uint) internal _birthdays; //tokenID -> UTCTime
}















