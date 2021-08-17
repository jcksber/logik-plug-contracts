// SPDX-License-Identifier: MIT
/*
 * Plug.sol
 *
 * Author: Jack Kasbeer
 * Created: August 3, 2021
 *
 * Price: ~0.5 ETH
 *
 * Description: An ERC-721 token that will change based on (1) time held by a single owner and
 * 				(2) trades between owners; the different versions give you access to airdrops.
 *
 *  - As long as the owner remains the same, every 60 days, the asset will acquire more "juice" 
 * 	  not only updating the asset, but allowing the owner to receive more airdrops from other 
 *    artists.  This means after a year, the final asset (and most valuable) will now be in the 
 *    owner's wallet (naturally each time, the previous asset is replaced).
 *  - If the NFT changes owners, the initial/day 0 asset is now what will be seen by the owner,
 *    and they'll have to wait a full year to achieve "final asset status" (gold)
 *  - Asset cycle: 1. 0 months (< 60 days): 1% juice
 *				   2. 2 months (60 days): 17% juice
 *				   3. 4 months (120 days): 33% juice
 *				   4. 6 months (180 days): 50% juice
 *				   5. 8 months (240 days): 66% juice
 *				   6. 10 months (300 days): 87% juice 
 *				   7. 12 months (360 days): 100% juice
 *				   8. 48 months (1440 days): Permanent 100% (grandfather)
 *  - If a Plug is a Grandfather (final state), it means that it will never lose juice again,
 *    even if it is transferred.
 */

pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/CountersUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

contract PlugTest4 is ERC721Upgradeable, OwnableUpgradeable {

	using CountersUpgradeable for CountersUpgradeable.Counter;
	CountersUpgradeable.Counter private _tokenIds;

	uint constant NUM_ASSETS = 8;
	uint constant MAX_NUM_PLUGS = 88;//this number is important

	// Production hashes
	string constant HASH_0 = "QmeyKF86ke66i339GAbHrtiG5DHchqo7oRLb5ky419bhG4"; //1% Plug
	string constant HASH_1 = "QmTe7qzmMAV7NMGGvaqRcnaoFUoAYdcKz1cyZz4Yd8vBNV";
	string constant HASH_2 = "QmXrJgAJCcmh38tXCBBetcXx3Wxrctqsg6ve8J76FDorkF";
	string constant HASH_3 = "Qmbborkd6TyXofhWsFD9c2H6PzYii1VNkW7GjqT99kon6t";
	string constant HASH_4 = "QmUwgMPZKYQJ7B7C7aV3AUnA3hqBxrEFKpNKUGYuh4YBf4";
	string constant HASH_5 = "QmYSa8bVxwS8tQ4fRtaqZjucEVpQJNDHg2TuT4P12aqchX";
	string constant HASH_6 = "QmeJPegPQLG3tfvmzVueWtbAr1Ww5PZ6b2ZFwrht71xTNx"; //100% Plug
	string constant HASH_7 = ""; //grandfather Plug

	// Our list of IPFS hashes for each of the 7 Plugs (varying juice levels)
	string [NUM_ASSETS] _assetHashes = [HASH_0, HASH_1, 
										HASH_2, HASH_3, 
										HASH_4, HASH_5, 
										HASH_6, HASH_7];

	// Keep track of the "last transfer time" (o.t.w. mint time) for each token ID
	// tokenID -> UTCTime
	mapping(uint256 => uint) private _lastTransferTimes;
	// Keep track of "grandfather" Plugs
	// tokenID -> true/false
	mapping(uint256 => bool) private _grandfatherPlugs;

	// Create Plug
	function __Plug_init() internal initializer { 
		__ERC721_init("the Plug", "");
	}


	/*** CORE FUNCTIONS ***/

	// Mint a single Plug
	function mintPlug(address recipient) public onlyOwner returns (uint256)
	{
		_tokenIds.increment();

		uint256 newId = _tokenIds.current();
		_safeMint(recipient, newId);

		// Add this to our mapping of "last transfer times"
		_lastTransferTimes[newId] = block.timestamp;

		return newId;
	}

	// Burn a single Plug (destroy forever)
	function burnPlug(uint256 tokenId) public virtual 
	{
		require(_isApprovedOrOwner(_msgSender(), tokenId), "Burnable: caller is not approved to burn");

		_burn(tokenId);
	}

	// Any Plug transfer this will be called beforehand (updating the transfer time)
	// If a Plug is now a Grandfather, it's timestamp won't be updated so its	
	function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual override
    {	
    	// If the "4 years" have passed, this is now a Grandfather token
    	if (_exists(tokenId) && countDaysPassed(tokenId) >= 1440 && !_isGrandfather(tokenId)) {
			_setGrandfather(tokenId);
		} else {// o.t.w. change the timestamp on a transfer
			_lastTransferTimes[tokenId] = block.timestamp;
		}
    }


	/*** "THE PLUG" FUNCTIONS **/

	// Override 'tokenURI' to account for asset/hash cycling
	function tokenURI(uint256 tokenId) public view virtual override returns (string memory) 
	{	
		require(_exists(tokenId), "Plug (ERC721Metadata): URI query for nonexistent token");

		string memory baseURI = _baseURI();
		string memory hash = _tokenHash(tokenId);
		
		return string(abi.encodePacked(baseURI, hash));
	}

	// List the owners for a certain level (determined by assetHash)
	// We'll need this for airdrops and benefits
	function listLevelOwners(string memory assetHash) public view returns (address[] memory)
	{
		require(_hashExists(assetHash), "Plug (ERC721Metadata): IPFS hash nonexistent");

		address[] memory levelOwners = new address[](MAX_NUM_PLUGS);
		uint counter = 0; //keeps track of where we are in 'owners'

		// Go thru list of created token id's (existing Plugs) so far
		uint tokenId;
		uint lastTokenId = _tokenIds.current();
		for (tokenId = 1; tokenId <= lastTokenId; tokenId++) {

			// Find the IPFS hash associated with this token ID
			string memory hash = _tokenHash(tokenId);

			// If this is equal to the hash we're looking for (assetHash)
			// then determine the owner of the token and add it to our list
			if (_stringsEqual(hash, assetHash)) {
				address owner = ownerOf(tokenId);
				levelOwners[counter] = owner;
				counter++;
			}
		}

		return levelOwners;
	}

	// Turn a Plug into a Grandfather Plug
	function claimGrandfatherPlug(uint256 tokenId) public onlyOwner
	{
		require(!_isGrandfather(tokenId), "Plug: tokenId is already Grandfather");

		if (countDaysPassed(tokenId) >= 1440) {
			_setGrandfather(tokenId);
		}
	}

	// Determine if a particular Plug is "grandfather"d in
	function _isGrandfather(uint256 tokenId) internal view returns (bool)
	{
		return _grandfatherPlugs[tokenId];
	}

	// Set tokenId as a Grandfather Plug
	function _setGrandfather(uint256 tokenId) internal
	{
		_grandfatherPlugs[tokenId] = true;
	}


	/*** HELPER FUNCTIONS ***/

	// All of the asset's will be pinned to IPFS
	function _baseURI() internal view virtual override returns (string memory)
	{
		return "https://ipfs.io/ipfs/";
	}

	// Based on the number of days that have passed since the last transfer of
	// ownership, this function returns the appropriate IPFS hash
	function _tokenHash(uint256 tokenId) internal virtual view returns (string memory)
	{
		require(_exists(tokenId), "Plug (ERC721Metadata): URI query for nonexistent token");

		// TEST LOGIC /////////////////////////////////////////////////////////////
		// Calculate the number of hours that have passed for 'tokenId'
		uint hoursPassed = countHoursPassed(tokenId);
		// Order is "reversed" for cleaner code
		if (hoursPassed >= 24 || _isGrandfather(tokenId)) {
			return HASH_7;
		} else if (hoursPassed >= 6) {
			return HASH_6;
		} else if (hoursPassed >= 5) {
			return HASH_5;
		} else if (hoursPassed >= 4) {
			return HASH_4;
		} else if (hoursPassed >= 3) {
			return HASH_3;
		} else if (hoursPassed >= 2) {
			return HASH_2;
		} else if (hoursPassed >= 1) {
			return HASH_1;
		} else {
			return HASH_0; 
		}

		// PRODUCTION LOGIC ///////////////////////////////////////////////////////
		// Calculate days gone by for this particular token with 'tokenId'
		// uint daysPassed = (block.timestamp - _lastTransferTimes[tokenId]) / 1 days;
		// // The logic here is "reversed" for cleaner code
		// if (daysPassed >= 1440) {
		//  return HASH_7;
		// } else if (daysPassed >= 360) {
		// 	return HASH_6;
		// } else if (daysPassed >= 300) {
		// 	return HASH_5;
		// } else if (daysPassed >= 240) {
		// 	return HASH_4;
		// } else if (daysPassed >= 180) {
		// 	return HASH_3;
		// } else if (daysPassed >= 120) {
		// 	return HASH_2;
		// } else if (daysPassed >= 60) {
		// 	return HASH_1;
		// } else { //if 60 days haven't passed, the initial asset/Plug is returned
		// 	return HASH_0; 
		// }
	}

	// Determine if 'assetHash' is one of the IPFS hashes for Plug
	function _hashExists(string memory assetHash) internal pure returns (bool) 
	{
		return _stringsEqual(assetHash, HASH_0) || 
			   _stringsEqual(assetHash, HASH_1) ||
			   _stringsEqual(assetHash, HASH_2) ||
			   _stringsEqual(assetHash, HASH_3) ||
			   _stringsEqual(assetHash, HASH_4) ||
			   _stringsEqual(assetHash, HASH_5) ||
			   _stringsEqual(assetHash, HASH_6) ||
			   _stringsEqual(assetHash, HASH_7);
	}

	// Determine if two strings are equal using the length + hash method
	function _stringsEqual(string memory a, string memory b) internal pure returns (bool)
	{
		bytes memory A = bytes(a);
		bytes memory B = bytes(b);

		if (A.length != B.length) {
			return false;
		} else {
			return keccak256(A) == keccak256(B);
		}
	}


	/****** TIME SHIT ******/

	// Number of minutes that have passed since transfer/mint
	function countMinutesPassed(uint256 tokenId) public view returns (uint16) 
	{
	    require(_exists(tokenId), 
	    	"Plug (ERC721Metadata): time (minutes) query for nonexistent token");
		return uint16((block.timestamp - _lastTransferTimes[tokenId]) / 1 minutes);
	}

	// Number of hours that have passed since transfer/mint
	function countHoursPassed(uint256 tokenId) public view returns (uint16) 
	{
		require(_exists(tokenId), 
			"Plug (ERC721Metadata): time (hours) query for nonexistent token");
		return uint16((block.timestamp - _lastTransferTimes[tokenId]) / 1 hours);
	}

	// Number of days that have passed since transfer/mint
	function countDaysPassed(uint256 tokenId) public view returns (uint16) 
	{
		require(_exists(tokenId), 
			"Plug (ERC721Metadata): time (days) query for nonexistent token");
		return uint16((block.timestamp - _lastTransferTimes[tokenId]) / 1 days);
	}
}
