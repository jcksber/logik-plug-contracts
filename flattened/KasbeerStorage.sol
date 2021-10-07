// Dependency file: @openzeppelin/contracts/utils/Counters.sol

// SPDX-License-Identifier: MIT

// pragma solidity ^0.8.0;

/**
 * @title Counters
 * @author Matt Condon (@shrugs)
 * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
 * of elements in a mapping, issuing ERC721 ids, or counting request ids.
 *
 * Include with `using Counters for Counters.Counter;`
 */
library Counters {
    struct Counter {
        // This variable should never be directly accessed by users of the library: interactions must be restricted to
        // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
        // this feature: see https://github.com/ethereum/solidity/issues/4637
        uint256 _value; // default: 0
    }

    function current(Counter storage counter) internal view returns (uint256) {
        return counter._value;
    }

    function increment(Counter storage counter) internal {
        unchecked {
            counter._value += 1;
        }
    }

    function decrement(Counter storage counter) internal {
        uint256 value = counter._value;
        require(value > 0, "Counter: decrement overflow");
        unchecked {
            counter._value = value - 1;
        }
    }

    function reset(Counter storage counter) internal {
        counter._value = 0;
    }
}


// Root file: contracts/KasbeerStorage.sol

/*
 * KasbeerStorage.sol
 *
 * Author: Jack Kasbeer
 * Created: August 21, 2021
 */

pragma solidity >=0.5.16 <0.9.0;

// import "@openzeppelin/contracts/utils/Counters.sol";

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
	//@dev Ownership
	mapping (address => bool) internal _squad;
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

