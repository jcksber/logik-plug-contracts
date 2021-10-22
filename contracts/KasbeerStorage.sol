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
    bytes4 internal constant _INTERFACE_ID_ROYALTIES = 0xcad96cca;

	//@dev Important numbers
	uint constant NUM_ASSETS = 8;
	uint constant MAX_NUM_TOKENS = 888;
	// uint constant TOKEN_WEI_PRICE = 88800000000000000;//0.0888 ETH
	uint constant TOKEN_WEI_PRICE = 1000000000000000;

	//@dev Properties
	string internal contractUri;
	address public payoutAddress;

	//@dev Initial production hashes
	//Our list of IPFS hashes for each of the "Nomad" 8 Plugs (varying juice levels)
	string [NUM_ASSETS] normHashes = ["QmZqQ3A92mJbWaiRm8V8aQM4Ms2R8CBanZbsvorsqF2B9w",
									  "QmXSFCcQzhHc1YG4VPMtLpqaCQ9ixaGUZXkNvC12WnWV1S",
									  "QmTja6dgUXQURvWxi7kQmBHpXVKz413Qodgy7WWaQf7upK",
									  "QmSrufzXcpN38JKRK3vSwx5vQLwW7Lpk7uERUqZ2swePBS",
									  "QmVspk2z5CxUqdRrYrqaKf396t28sjbRdGEUDjrd3WLGEJ",
									  "QmXUi4eS1FouJmwaZFnAxARhkJ8kLGDGcnZcgaW8CBGpmV",
									  "QmQ6VhtxVFAXGqQGytCsRS7qLx57sNdLne8cxDCVaUy895",
									  "QmbsYqEXRxZAkdGoJcpQJwj8mF9re1KwLJJpdKgLze6PXa"];
	//Our list of IPFS hashes for each of the "Chicago" 8 Plugs (varying juice levels)
	string [NUM_ASSETS] chiHashes = ["Qmaopi7ggB9g4VUTrcyEBbng5tPoA18xKmFuc4NBa4NprS",
									 "QmfPSqaXgA7RX5JeBTG9957hu2Nab9EVfyqZkRumaXszJ6",
									 "QmSCs6GudPdTpz8mBvzkw2rmhi2mVnGBLL2AiiBghkN6iH",
									 "QmZGqgxMKbZ5BBDwWAAyUVfYq1uUhgYLKUTDdj2cCNFU4A",
									 "QmU6QdNob38HT6iD2FjbJVNCjxk2GydVbuFiWKnvmkGEfP",
									 "QmNfQG1DHST73SCxMJeujPBpAvzzN2tj5E31TMwwS7CDdZ",
									 "Qmf8smxvPw4JmnyR1pWSYzYvyw7CpZxU1uoRw4k1izqkoy",
									 "QmYsUU1s3Q2XVpmqbDRuzok3bYUVZHkAbBLTEPpe9aaUgJ"];
	//Our list of IPFS hashes for each of the "Chicago" 8 Plugs (varying juice levels)
	string [NUM_ASSETS] stlHashes = ["QmZ5mc6n4bjecJBRRbP9uy6P7GFfkau7dCvNXEhCpdztfJ",
									 "QmWXmi1vFjGLuBCR7wrZ41hh949z8AMgYZxYyPEohvpip3",
									 "QmbGSvuGDPup1A3FMtk92y5kTBrWpGKxjRMju5UXbVVpfY",
									 "QmXuM5wbVDyJxySrnwC6XV2iJKUyJSawu6vdwmAYewzRCh",
									 "QmbJMzuDtQZn4heKNfyjHh6uu4fZC5hiSFq3ypUeeKoHEm",
									 "QmTHc9uMkNDmJHyz1KjZN5P3p1bJGtTFhv6RTXr48sXQNT",
									 "QmWKpChXGjvEg8FB8bnz2pniPfywZFwj6aUx4uD6NXHfq5",
									 "QmV3tboVKBMo9K2Fd1rGAoGFY3QKoEUERNFbspGvphjHVc"];
}
