// SPDX-License-Identifier: MIT
/*
 * JuiceBoxStorage.sol
 *
 * Author: Jack Kasbeer
 * Created: October 27, 2021
 */

pragma solidity >=0.5.16 <0.9.0;

import "@openzeppelin/contracts/utils/Counters.sol";

//@title A storage contract for relevant data
//@author Jack Kasbeer (@jcksber, @satoshigoat)
contract KasbeerStorage {

	//@dev These take care of token id incrementing
	using Counters for Counters.Counter;
	Counters.Counter internal _tokenIds;

	//@dev These are needed for contract compatability
	uint256 constant public royaltyFeeBps = 1500; // 15%
    bytes4 internal constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
    bytes4 internal constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
    bytes4 internal constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
    bytes4 internal constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
    bytes4 internal constant _INTERFACE_ID_EIP2981 = 0x2a55205a;
    bytes4 internal constant _INTERFACE_ID_ROYALTIES = 0xcad96cca;

	//@dev Important numbers
	uint constant NUM_ASSETS = 3;
	uint constant MAX_NUM_TOKENS = 444;//NOTE: change later!

	//@dev Properties
	string internal contractUri;
	address public payoutAddress;

	//@dev Initial production hashes
	string [NUM_ASSETS] boxHashes = ["", "", ""];

	//@dev Associated weights of probability for hashes
	uint16 [NUM_ASSETS] boxWeights = [377, 44, 22];//based on MAX_NUM_TOKENS
								   //0.85,0.1,0.05 
}
