// SPDX-License-Identifier: MIT
/*
 * PlugUpgradeable.sol
 *
 * Author: Jack Kasbeer
 * Created: August 21, 2021
 */

pragma solidity ^0.7.3;

import "./KasbeerMade.sol";
import "./PlugStorage.sol";

contract PlugUpgradeable is KasbeerMade, PlugStorage {


	constructor() {}

	// @dev Allows us to update the IPFS hash values
	function updateHash(uint8 _hash_num, string memory _str) public isSquad {
		require(0 <= _hash_num && _hash_num < NUM_ASSETS, 
			"PlugStorage: _hash_num out of bounds");
		// Can only update one hash at a time...
		assetHashes[_hash_num] = _str;
	}
}