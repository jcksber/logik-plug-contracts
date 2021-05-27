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
	constructor() public ERC1155("https://logik-genesis-api.herokuapp.com/api/stamps/0/{id}.json")
	{
		_mint(msg.sender, USA, NUM_PASSPORTS, "");
		_mint(msg.sender, MEXICO, NUM_PASSPORTS, "");
		_mint(msg.sender, JAPAN, NUM_PASSPORTS, "");
		_mint(msg.sender, COUNTRY3, NUM_PASSPORTS, "");
		_mint(msg.sender, COUNTRY4, NUM_PASSPORTS, "");
		_mint(msg.sender, COUNTRY5, NUM_PASSPORTS, "");
		_mint(msg.sender, COUNTRY6, NUM_PASSPORTS, "");
		_mint(msg.sender, COUNTRY7, NUM_PASSPORTS, "");
	}

	/* 
	 * This function should transfer a stamp from LOGIK/me to 'recipient'
	 * if 'recipient' is a LOGIKPassport holder...
	 * => it's going to need to interact with LOGIKPassport to check various things like:
	 *    1. is 'recipient' and owner?
	 *    2. does 'recipient' already have the requested stamp?
	 *
	 * Returns a uint32 that will correspond to an error code:
	 * 0 => success
	 * 1 => failure, 'recipient' doesn't own a LOGIKPassport
	 * 2 => failure, 'recipient' already owns the NFT for 'stamp_id'
	 * 3 => some other failure
	 */
	function awardStamp(address recipient, uint256 stamp_id) 
		public onlyOwner
		returns (uint32)
	{
		require(recipient != address(0), "ERC1155: cannot award stamp for the zero address");
		
		/*
		IN MY HEAD...

		The webapp should do all the dirty work in determining where someone is and which
		stamp should be transferred to the user.
		This means the ranges of latitudes and longitudes for each nft are in the webapp's code,
		not in the smart contract code.

		I don't want this function to ever be reached unless it has been already pre-determined
		that the user is in an area of the world that qualifies for a stamp

		^^ This is why the stamp_id is being passed in: the webapp will determine which id to send
		based on the results obtained from ip-api.io

		THEREFORE, once we have reached this function call, it should do the follow
		(the order here might be slightly off i need to check best practices again):
		*/

		// 1. Prelminary error checking?

		// 2. Make a call to LOGIKPassport and make sure 'recipient' is an owner

		// 3. Make a call to parent contract and determine if 'recipient' already has the
		//    NFT for stamp_id

		// 4. Update the state variables to indicate this person has claimed 'stamp_id'

		// 5. Transfer a single stamp (with 'stamp_id') to 'recipient'
	}
}






