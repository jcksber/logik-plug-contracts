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

	//@dev Ownership - list of squad members (owners)
	mapping (address => bool) internal _squad;

	
	/*** SQUAD FUNCTIONS ************************************************************************/

	//@dev Custom "approved" modifier because I don't like that language
	modifier isSquad()
	{
		require(isInSquad(msg.sender), "KasbeerAccessControl: Caller not part of squad.");
		_;
	}

	//@dev Determine if address `a` is an approved owner
	function isInSquad(address a) 
		public view 
		returns (bool) 
	{
		return _squad[a];
	}

	//@dev Add `a` to the squad
	function addToSquad(address _a)
		onlyOwner 
		public
	{
		require(!isInSquad(_a), "KasbeerAccessControl: Address already in squad.");
		_squad[_a] = true;
		emit SquadMemberAdded(_a);
	}

	//@dev Remove `a` from the squad
	function removeFromSquad(address a_)
		onlyOwner
		public
	{
		require(isInSquad(a_), "KasbeerAccessControl: Address already not in squad.");
		_squad[a_] = false;
		emit SquadMemberRemoved(a_);
	}


	/*** WHITELIST *****************************************************************************
	 * 
	 * This implementation of a whitelist/pre-sale-list using a mapping from addresses to
	 * booleans for the whitelisted members to be available on-chain, and a flag (uint8) 
	 * to indicate whether or not the whitelist is currrently active/inactive.
	 *
	 * Functions are provided both for (1) adding a single address to the whitelist, and (2) 
	 * for adding a list of addresses to the whitelist.  The second method 
	 * (`bulkAddToWhitelist`) is the preferred one as it will save on gas dramatically.
	 *
	 * Therefore, this allows for easy control in a cost-efficient way to have a dynamic whitelist
	 * in addition to the ability to enable and disable it.
	 */

	 //@dev Emitted when address has been added to `_whitelist`
	event WhitelistAddressAdded(address indexed addy);

	//@dev Emitted when whitelist activated
	event WhitelistActivated();

	//@dev Emitteed when whitelist deactivated
	event WhitelistDeactivated();

	//@dev Whitelist mapping for client addresses
	mapping (address => bool) internal _whitelist;

	//@dev Whitelist flag for active/inactive states
	uint8 whitelistActive;

	//@dev Determine if someone is in the whitelsit
	modifier onlyWhitelist(address a)
	{
		require(isInWhitelist(a));
		_;
	}

	//@dev Prevent non-whitelist minting functions from being used 
	// if `whitelistActive` == 1
	modifier whitelistDisabled()
	{
		require(whitelistActive == 0, "KasbeerAccessControl: whitelist still active");
		_;
	}

	//@dev Require that the whitelist is currently enabled
	modifier whitelistEnabled() 
	{
		require(whitelistActive == 1, "KasbeerAccessControl: whitelist not active");
		_;
	}

	//@dev Turn the whitelist on
	function activateWhitelist()
		isSquad
		whitelistDisabled
		public
	{
		whitelistActive = 1;
		emit WhitelistActivated();
	}

	//@dev Turn the whitelist off
	function deactivateWhitelist()
		isSquad
		whitelistEnabled
		public
	{
		whitelistActive = 0;
		emit WhitelistDeactivated();
	}

	//@dev Prove that one of our whitelist address owners has been approved
	function isInWhitelist(address a) 
		public view 
		returns (bool)
	{
		return _whitelist[a];
	}

	//@dev Add a single address to whitelist
	function addToWhitelist(address _a) 
		isSquad
		public
	{
		require(_whitelist[_a] == false, "KasbeerAccessControl: already whitelisted"); 
		//here we care if address already whitelisted to save on gas fees
		_whitelist[_a] = true;
		emit WhitelistAddressAdded(_a);
	}

	//@dev Add a list of addresses to the whitelist
	function bulkAddToWhitelist(address[] memory _addys) 
		isSquad
		public
	{
		require(_addys.length > 1, "KasbeerAccessControl: use `addToWhitelist` instead");
		uint8 i;
		for (i = 0; i < _addys.length; i++) {
			if (!_whitelist[_addys[i]]) {
				_whitelist[_addys[i]] = true;
				emit WhitelistAddressAdded(_addys[i]);
			}//don't emit event for address if already in whitelist
		}
	}
}
