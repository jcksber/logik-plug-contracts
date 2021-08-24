// SPDX-License-Identifier: MIT
/*
 * KasbeerStorage.sol
 *
 * Author: Jack Kasbeer
 * Created: August 21, 2021
 */

pragma solidity >=0.5.16 <0.9.0;

import "@openzeppelin/contracts/utils/Counters.sol";

//@title The Plug storage contract
//@author Jack Kasbeer (@jcksber, @satoshigoat)
contract KasbeerStorage {

	//@dev Emitted when someone is added to `_squad`
	event SquadMemberAdded(address indexed member);
	//@dev Emitted when someone is removed from `_squad`
	event SquadMemberRemoved(address indexed member);
	//@dev Emitted when a token is minted
	event ERC721Minted(uint256 indexed tokenId);
	//@dev Emitted when a token is burned
	event ERC721Burned(uint256 indexed tokenId);
	//@dev Emitted when an ipfs hash is updated
	event HashUpdated(string indexed newHash);

	//@dev These take care of token id incrementing
	using Counters for Counters.Counter;
	Counters.Counter internal _tokenIds;
	// Counters.Counter internal _hashIds;
	//@dev Ownership
	mapping (address => bool) internal _squad;

	//NOTE: maybe replace this with a struct that has a number of assets,
	// and a mapping from ipfsHash -> position
	//@dev Important numbers
	uint constant NUM_ASSETS = 8;
	//@dev Production hashes
	string internal HASH_0 = "QmSJQmBV5crGcmq54WUB22SRw9SGsp1YSaxfenQEbZ5qTD"; //1% Plug
	string internal HASH_1 = "QmY7HTXyHk4UQUr8PUQC3rUQD9fFa8dVutyRBZSdorWhMv";
	string internal HASH_2 = "QmSUTwTS3aALgZHyuvYV1ys3d5FHbeJ24MDTfA4WCkncop";
	string internal HASH_3 = "QmcciA32wMXVJpGQCyAumXSa9QT7FKvh1tDBgYxELm7THu";
	string internal HASH_4 = "QmSfr7uuVjm4ddzYkwR1bD1u8KRSueSfKYx7w3tGjstcgt";
	string internal HASH_5 = "QmUm9aTEEBgQTSpE24Q1fCHeBzntAd9nguJLFDFkSjmNPv";
	string internal HASH_6 = "QmUBsLHrMFLUjApCrnd8DUjk2noe52gN48JHUF1WTCuw6b"; //100% Plug
	string internal HASH_7 = "QmPqezAYfYy1pjdi3MstdnT1F9NAmvcqtvrFpY7o6HGTRE"; //alchemist Plug
	//@dev Our list of IPFS hashes for each of the 8 Plugs (varying juice levels)
	string [NUM_ASSETS] assetHashes = [HASH_0, HASH_1, 
									   HASH_2, HASH_3, 
									   HASH_4, HASH_5, 
									   HASH_6, HASH_7];
}

