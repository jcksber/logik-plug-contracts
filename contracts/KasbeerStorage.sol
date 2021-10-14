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

	//@dev Emitted when a token is minted
	event ERC721Minted(uint256 indexed tokenId);
	//@dev Emitted when a token is burned
	event ERC721Burned(uint256 indexed tokenId);
	//@dev Emitted when an ipfs hash is updated
	event HashUpdated(uint8 indexed group, string indexed newHash);
	//@dev Emitted when token is transferred
	event PlugTransferred(address indexed from, address indexed to);

	//@dev These take care of token id incrementing
	using Counters for Counters.Counter;
	Counters.Counter internal _tokenIds;

	//@dev Important numbers
	uint constant NUM_ASSETS = 8;
	uint constant MAX_NUM_PLUGS = 888;
	uint constant PLUG_WEI_PRICE = 88800000000000000;

	//@dev Production hashes
	//Nomad (non-chicago, non-st louis)
	string internal NHASH_0 = "QmWCRLCpoZFMGsDGUbBPRR83vSbttvfX76bKH7z8iJ44sA"; //1% Plug
	string internal NHASH_1 = "QmbNtFBSV8fyATBU4iSK6vNzrp69ssX7CSyn4VKKsYuEBs";
	string internal NHASH_2 = "QmRuTjtQLKiy2nQDUH3zEmsuhPPfJV5JNB9nCrknqPPw1P";
	string internal NHASH_3 = "QmPMzwE5QnRzvLwGrqxBiS26ZrgBCYiYWyMxz4xVBctZRC";
	string internal NHASH_4 = "QmVDnUtPMEiU8fXJJWJTV7v5ng5LbPQ1ztSCpKq5SwaWyt";
	string internal NHASH_5 = "QmVRapzJe2zHHHEmFsweD4HUtKMdU3cPFJM7M6rYe9pygS";
	string internal NHASH_6 = "QmcGtch2D8SWeTZTW8J8VnnGmDK1rPuhW4yhwgxbtCgaNv"; //100% Plug
	string internal NHASH_7 = "QmW2UpMiGDP21wxakmCAWLktEgZjUUVH1pPdPfY1uq1iDL"; //alchemist Plug
	//Chicago
	string internal CHASH_0 = "QmVUwXw8uA8DsGDMPQrnD3egLTPasDAxCmqLiHQnnm1bkm"; //1% Plug
	string internal CHASH_1 = "QmWBzr8ojvf7vDoYai4KZyhXdBMMM81Cfwh6uUGhmiNdHZ";
	string internal CHASH_2 = "Qmam6xkDbXLnCZtryPCvkVX5auGmJZ16oJj81w17dmwWCL";
	string internal CHASH_3 = "QmPenaV4Z3PewX5BGga7qJ7tp58oXyrLKUsQD4ikCiKXVU";
	string internal CHASH_4 = "QmQG49j1kGWWBNKqSk2U2VCqq5au7rAnao1D6Q5cD9HiAP";
	string internal CHASH_5 = "QmQh6zBpQknZkrh3jYaGnESoNXBTY2ezEuWXT8iLcAUTfP";
	string internal CHASH_6 = "QmWYxnsrZMKdYa5w4ZejmfSLAAh47Qb416Uyu2kgzkFaT5"; //100% Plug
	string internal CHASH_7 = "QmTWF64DUNWH6uTVCkaL9GhVjNCXi6derawD2gcKry5N3o"; //alchemist Plug
	//St. Louis
	string internal LHASH_0 = "QmRwZQJPRzrFwzFVSeHB4mxwcyEbSf2oaCwdbLFwvguAVZ"; //1% Plug
	string internal LHASH_1 = "QmTr4WF8Q9JrbfRdsVDM5UpyJAC9XkVcsiCGZkPQK88KXW";
	string internal LHASH_2 = "QmXRde86henhSE24oMGVzXG2D1E4pMHqSeAoL6cje51pUQ";
	string internal LHASH_3 = "QmWDwZvJZJ3PqwrhHykcppu5Bmbz5jY4Muy4fFtzyFLMFs";
	string internal LHASH_4 = "QmdbevLc9tVnVveZTMn7Qe3TrD442pdn4BZgZ2rmdHm8tL";
	string internal LHASH_5 = "QmRZXYUBkYZMEpusrFBYxzo6pRJTNR7sD9P6mHf3HAbd73";
	string internal LHASH_6 = "QmWgRkgSwUetgCLFeTMmf8U4gpMvQ3Hv7RnUWKnD5Zvjt7"; //100% Plug
	string internal LHASH_7 = "QmPicKf7WfsPn1AWjAHeyDu9fMunn3qEW8Gk7GFyBXkPnR"; //alchemist Plug

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
