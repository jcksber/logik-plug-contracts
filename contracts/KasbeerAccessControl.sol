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

	//@dev Emitted when address has been added to `_whitelist`
	event WhitelistAddressAdded(address indexed addy);

	//@dev Emitted when whitelist activated
	event WhitelistActivated();

	//@dev Emitteed when whitelist deactivated
	event WhitelistDeactivated();

	//@dev Ownership
	mapping (address => bool) internal _squad;

	//@dev Whitelist
	// uint8 constant PRESALE_MAX = 200; //nahhhh
	mapping (address => bool) internal _whitelist;
	//@dev Whitelist flag
	uint8 whitelistActive;

	/*
	mapping hardcode for whitelist here
	*/


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


	/*** WHITELIST ******************************************************************************/

	//@dev Determine if someone is in the whitelsit
	modifier onlyValidAccess(address _addy)
	{
		require(isWhitelistAddress(_addy));
		_;
	}

	//@dev Prove that one of our whitelist address owners has been approved
	function isWhitelistAddress(address _addy) public view returns (bool)
	{
		return _whitelist[_addy];
	}

	//@dev Add a single address to whitelist
	function addAddressToWhitelist(address _addy) public isSquad returns (bool) 
	{
		require(_whitelist[_addy] == false, "KasbeerAccessControl: already whitelisted"); 
		//here we care if address already whitelisted to save on gas fees
		_whitelist[_addy] = true;
		emit WhitelistAddressAdded(_addy);

		return true;
	}

	//@dev Add a list of addresses to the whitelist
	function addAddressesToWhitelist(address[] memory _addys) public isSquad returns (bool)
	{
		uint8 i;
		for (i = 0; i < _addys.length; i++) {
			_whitelist[_addys[i]] = true; //don't care if address already whitelisted
			emit WhitelistAddressAdded(_addys[i]);
		}

		return true;
	}

	//@dev Turn the whitelist on
	function activateWhitelist() public isSquad returns (bool)
	{
		require(whitelistActive == 0, "KasbeerAccessControl: whitelist already active");

		whitelistActive = 1;
		emit WhitelistActivated();

		return true;
	}

	//@dev Turn the whitelist off
	function deactivateWhitelist() public isSquad returns (bool)
	{
		require(whitelistActive == 1, "KasbeerAccessControl: whitelist already inactive");

		whitelistActive = 0;
		emit WhitelistDeactivated();

		return true;
	}
}
