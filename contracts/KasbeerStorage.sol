// SPDX-License-Identifier: MIT
/*
 * KasbeerStorage.sol
 *
 * Author: Jack Kasbeer
 * Created: August 21, 2021
 */

pragma solidity >=0.5.16 <0.9.0;

import "@openzeppelin/contracts/utils/Counters.sol";

//@title A storage contract for relevant data
//@author Jack Kasbeer (@jcksber, @satoshigoat)
contract KasbeerStorage {

	//@dev These take care of token id incrementing
	using Counters for Counters.Counter;
	Counters.Counter internal _tokenIds;

	uint256 constant public royaltyFeeBps = 1500; // 15%
    bytes4 internal constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
    bytes4 internal constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
    bytes4 internal constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
    bytes4 internal constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
    bytes4 internal constant _INTERFACE_ID_EIP2981 = 0x2a55205a;

	//@dev Important numbers
	uint constant NUM_ASSETS = 8;
	uint constant MAX_NUM_TOKENS = 888;
	uint constant TOKEN_WEI_PRICE = 88800000000000000;//0.0888 ETH

	//@dev Properties
	string internal contractUri;

	//@dev Initial production hashes
	//Our list of IPFS hashes for each of the "Nomad" 8 Plugs (varying juice levels)
	string [NUM_ASSETS] normHashes = ["QmWCRLCpoZFMGsDGUbBPRR83vSbttvfX76bKH7z8iJ44sA",
									  "QmbNtFBSV8fyATBU4iSK6vNzrp69ssX7CSyn4VKKsYuEBs",
									  "QmRuTjtQLKiy2nQDUH3zEmsuhPPfJV5JNB9nCrknqPPw1P",
									  "QmPMzwE5QnRzvLwGrqxBiS26ZrgBCYiYWyMxz4xVBctZRC",
									  "QmVDnUtPMEiU8fXJJWJTV7v5ng5LbPQ1ztSCpKq5SwaWyt",
									  "QmVRapzJe2zHHHEmFsweD4HUtKMdU3cPFJM7M6rYe9pygS",
									  "QmcGtch2D8SWeTZTW8J8VnnGmDK1rPuhW4yhwgxbtCgaNv",
									  "QmW2UpMiGDP21wxakmCAWLktEgZjUUVH1pPdPfY1uq1iDL"];
	//Our list of IPFS hashes for each of the "Chicago" 8 Plugs (varying juice levels)
	string [NUM_ASSETS] chiHashes = ["QmVUwXw8uA8DsGDMPQrnD3egLTPasDAxCmqLiHQnnm1bkm",
									 "QmWBzr8ojvf7vDoYai4KZyhXdBMMM81Cfwh6uUGhmiNdHZ",
									 "Qmam6xkDbXLnCZtryPCvkVX5auGmJZ16oJj81w17dmwWCL",
									 "QmPenaV4Z3PewX5BGga7qJ7tp58oXyrLKUsQD4ikCiKXVU",
									 "QmQG49j1kGWWBNKqSk2U2VCqq5au7rAnao1D6Q5cD9HiAP",
									 "QmQh6zBpQknZkrh3jYaGnESoNXBTY2ezEuWXT8iLcAUTfP",
									 "QmWYxnsrZMKdYa5w4ZejmfSLAAh47Qb416Uyu2kgzkFaT5",
									 "QmTWF64DUNWH6uTVCkaL9GhVjNCXi6derawD2gcKry5N3o"];
	//Our list of IPFS hashes for each of the "Chicago" 8 Plugs (varying juice levels)
	string [NUM_ASSETS] stlHashes = ["QmRwZQJPRzrFwzFVSeHB4mxwcyEbSf2oaCwdbLFwvguAVZ",
									 "QmTr4WF8Q9JrbfRdsVDM5UpyJAC9XkVcsiCGZkPQK88KXW",
									 "QmXRde86henhSE24oMGVzXG2D1E4pMHqSeAoL6cje51pUQ",
									 "QmWDwZvJZJ3PqwrhHykcppu5Bmbz5jY4Muy4fFtzyFLMFs",
									 "QmdbevLc9tVnVveZTMn7Qe3TrD442pdn4BZgZ2rmdHm8tL",
									 "QmRZXYUBkYZMEpusrFBYxzo6pRJTNR7sD9P6mHf3HAbd73",
									 "QmWgRkgSwUetgCLFeTMmf8U4gpMvQ3Hv7RnUWKnD5Zvjt7",
									 "QmPicKf7WfsPn1AWjAHeyDu9fMunn3qEW8Gk7GFyBXkPnR"];
}
