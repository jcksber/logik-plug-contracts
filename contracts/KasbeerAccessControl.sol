// SPDX-License-Identifier: MIT
/*
 * KasbeerAccessControl.sol
 *
 * Author: Jack Kasbeer
 * Created: October 14, 2021
 *
 * This is an extension of `Ownable` to allow a larger set of addresses to have
 * certain control in the inheriting contracts, in addition to providing logic 
 * for a whitelist that can be used for pre-sales.
 */

pragma solidity >=0.5.16 <0.9.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract KasbeerAccessControl is Ownable {

	//@dev Emitted when someone is added to `_squad`
	event SquadMemberAdded(address indexed member);
	//@dev Emitted when someone is removed from `_squad`
	event SquadMemberRemoved(address indexed member);
	//@dev Emitted when someone is added to `_whitelist`
	//event WhitelistMemberAdded(address indexed member);
	//@dev Emitted when someone is removed from `_whitelist`
	//event WhitelistMemberRemoved(address indexed member);
	//@dev Emitted when whitelist is activated/deactivated
	event WhitelistActivated(bool indexed flag);

	//@dev Ownership
	mapping (address => bool) internal _squad;
	//@dev Whitelist
	mapping (address => bool) internal _whitelist;

	//@dev Flag for whitelist being active (1) or not (0)
	//uint8 whitelistActive;


	/*** SQUAD FUNCTIONS ************************************************************************/

	//@dev Custom "approved" modifier because I don't like that language
	modifier isSquad()
	{
		require(isInSquad(msg.sender), "KasbeerAccessControl: Caller not part of squad.");
		_;
	}

	//@dev Determine if address 'a' is an approved owner
	function isInSquad(address a) public view returns (bool) 
	{
		return _squad[a];
	}

	//@dev Add someone to the squad
	function addToSquad(address a) public onlyOwner
	{
		require(!isInSquad(a), "KasbeerAccessControl: Address already in squad.");
		_squad[a] = true;
		emit SquadMemberAdded(a);
	}

	//@dev Remove someone from the squad
	function removeFromSquad(address a) public onlyOwner
	{
		require(isInSquad(a), "KasbeerAccessControl: Address already not in squad.");
		_squad[a] = false;
		emit SquadMemberRemoved(a);
	}


	/*** WHITELIST FUNCTIONS ********************************************************************/

	// //@dev Turn the whitelist on
	// function activateWhiteList() public isSquad 
	// { 
	// 	whitelistActive = 1;
	// 	emit WhitelistActivated(true);
	// }

	// //@dev Turn the whitelist off
	// function deactivateWhitelist() public isSquad 
	// { 
	// 	whitelistActive = 0;
	// 	emit WhitelistActivated(false);
	// }

	// //@dev Determine if an address is in the whitelist
	// function isInWhitelist(address a) public view returns (bool)
	// {
	// 	return _whitelist[a];
	// }

	// //@dev Add address to whitelist
	// function addToWhitelist(address a) public isSquad
	// {
	// 	require(!isInWhitelist(a), "KasbeerAccessControl: Address already in whitelist.");
	// 	_whitelist[a] = true;
	// 	emit WhitelistMemberAdded(a);
	// }

	// //@dev Remove address from whitelist
	// function removeFromWhitelist(address a) public isSquad 
	// {
	// 	require(isInWhitelist(a), "KasbeerAccessControl: Address not in whitelist.");
	// 	_whitelist[a] = false;
	// 	emit WhitelistMemberRemoved(a);
	// }
}
