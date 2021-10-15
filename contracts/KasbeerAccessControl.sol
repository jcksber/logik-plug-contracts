// SPDX-License-Identifier: MIT
/*
 * KasbeerAccessControl.sol
 *
 * Author: Jack Kasbeer
 * Created: October 14, 2021
 *
 * This is an extension of `Ownable` to allow a larger set of addresses to have
 * certain control in the inheriting contracts.
 */

pragma solidity >=0.5.16 <0.9.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract KasbeerAccessControl is Ownable {

	//@dev Emitted when someone is added to `_squad`
	event SquadMemberAdded(address indexed member);
	//@dev Emitted when someone is removed from `_squad`
	event SquadMemberRemoved(address indexed member);

	//@dev Ownership
	mapping (address => bool) internal _squad;


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
}
