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
	event HashUpdated(uint8 indexed group, string indexed newHash);

	//@dev These take care of token id incrementing
	using Counters for Counters.Counter;
	Counters.Counter internal _tokenIds;
	//@dev Ownership
	mapping (address => bool) internal _squad;
	//@dev Important numbers
	uint constant NUM_ASSETS = 8;
	//@dev Production hashes
	//Normal (non-chicago, non-st louis)
	string internal NHASH_0 = "QmSJQmBV5crGcmq54WUB22SRw9SGsp1YSaxfenQEbZ5qTD"; //1% Plug
	string internal NHASH_1 = "QmY7HTXyHk4UQUr8PUQC3rUQD9fFa8dVutyRBZSdorWhMv";
	string internal NHASH_2 = "QmSUTwTS3aALgZHyuvYV1ys3d5FHbeJ24MDTfA4WCkncop";
	string internal NHASH_3 = "QmcciA32wMXVJpGQCyAumXSa9QT7FKvh1tDBgYxELm7THu";
	string internal NHASH_4 = "QmSfr7uuVjm4ddzYkwR1bD1u8KRSueSfKYx7w3tGjstcgt";
	string internal NHASH_5 = "QmUm9aTEEBgQTSpE24Q1fCHeBzntAd9nguJLFDFkSjmNPv";
	string internal NHASH_6 = "QmUBsLHrMFLUjApCrnd8DUjk2noe52gN48JHUF1WTCuw6b"; //100% Plug
	string internal NHASH_7 = "QmPqezAYfYy1pjdi3MstdnT1F9NAmvcqtvrFpY7o6HGTRE"; //alchemist Plug
	//Chicago
	string internal CHASH_0 = ""; //1% Plug
	string internal CHASH_1 = "";
	string internal CHASH_2 = "";
	string internal CHASH_3 = "";
	string internal CHASH_4 = "";
	string internal CHASH_5 = "";
	string internal CHASH_6 = ""; //100% Plug
	string internal CHASH_7 = ""; //alchemist Plug
	//St. Louis
	string internal LHASH_0 = ""; //1% Plug
	string internal LHASH_1 = "";
	string internal LHASH_2 = "";
	string internal LHASH_3 = "";
	string internal LHASH_4 = "";
	string internal LHASH_5 = "";
	string internal LHASH_6 = ""; //100% Plug
	string internal LHASH_7 = ""; //alchemist Plug

	//@dev Our list of IPFS hashes for each of the "normal" 8 Plugs (varying juice levels)
	string [NUM_ASSETS] normHashes = [NHASH_0, NHASH_1, 
									  NHASH_2, NHASH_3, 
									  NHASH_4, NHASH_5, 
									  NHASH_6, NHASH_7];
	//@dev Our list of IPFS hashes for each of the "Chicago" 8 Plugs (varying juice levels)
	string [NUM_ASSETS] chiHashes = [CHASH_0, CHASH_1,
								     CHASH_2, CHASH_3,
								     CHASH_4, CHASH_5,
								     CHASH_6, CHASH_7];
	//@dev Our list of IPFS hashes for each of the "Chicago" 8 Plugs (varying juice levels)
	string [NUM_ASSETS] stlHashes = [LHASH_0, LHASH_1,
								     LHASH_2, LHASH_3,
								     LHASH_4, LHASH_5,
								     LHASH_6, LHASH_7];
}



















