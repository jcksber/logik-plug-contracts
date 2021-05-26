// SPDX-License-Identifier: MIT

/*
 * LOGIKStamp.sol
 *
 * Author: Jack Kasbeer
 * Created: May 19, 2021
 *
 * Description: An ERC-1155 token that will represent the stamps in the 
 * passport - each stamp is the same type/token LOGIK collectible, except 
 * with a different asset attached to it depending on the country of origin.
 *
 * These are initially only accessible to LOGIKPassport holders.
 *
 * Price: free to LOGIKPassport holders
 *
 * Address: 0x8322ff6ACa5EDB0c7575Fe853327b0Dd08f26e07
 */

pragma solidity ^0.7.3;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract LOGIKStampSet1 is ERC1155, Ownable {
    uint256 public constant NUM_PASSPORTS = 8;

    // Country token id's - each corresponds to a different token uri
	uint256 public constant USA = 0;
	uint256 public constant MEXICO = 1;
	uint256 public constant JAPAN = 2;
	uint256 public constant COUNTRY3 = 3;
	uint256 public constant COUNTRY4 = 4;
	uint256 public constant COUNTRY5 = 5;
	uint256 public constant COUNTRY6 = 6;
	uint256 public constant COUNTRY7 = 7;

	// For simplicity we will mint all items in the constructor but you could add minting 
	// functionality to the contract to mint on demand to customers.
	// uri example: "https://passport.nft/api/{id}.json"
	constructor() public ERC1155("../uri/metadata{id}.json") {
		_mint(msg.sender, USA, NUM_PASSPORTS, "");
		_mint(msg.sender, MEXICO, NUM_PASSPORTS, "");
		_mint(msg.sender, JAPAN, NUM_PASSPORTS, "");
		_mint(msg.sender, COUNTRY3, NUM_PASSPORTS, "");
		_mint(msg.sender, COUNTRY4, NUM_PASSPORTS, "");
		_mint(msg.sender, COUNTRY5, NUM_PASSPORTS, "");
		_mint(msg.sender, COUNTRY6, NUM_PASSPORTS, "");
		_mint(msg.sender, COUNTRY7, NUM_PASSPORTS, "");
	}

	// the counter thing is what's confusing me here... not sure how to 
	// make use of this code....
	// using Counters for Counters.Counter;
 //    Counters.Counter private _tokenIds;

 //    function mintNFT(address recipient, string memory tokenURI)
 //        public onlyOwner
 //        returns (uint256)
 //    {
 //        _tokenIds.increment();

 //        uint256 newItemId = _tokenIds.current();
 //        _mint(recipient, newItemId);
 //        _setTokenURI(newItemId, tokenURI);

 //        return newItemId;
 //    }
}






