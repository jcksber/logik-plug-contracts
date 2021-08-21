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
 *				   8. 48 months (1440 days): Permanent 100% (sensei)
 *  - If a Plug is a Alchemist (final state), it means that it will never lose juice again,
 *    even if it is transferred.
 */

pragma solidity ^0.7.3;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "./KasbeerMade.sol";
import "./PlugStorage.sol";

//@title The Plug
//@author Jack Kasbeer (@jcksber, @satoshigoat)
contract Plug is ERC721, KasbeerMade, PlugStorage {

	using Counters for Counters.Counter;

	// @dev Create Plug
	constructor() ERC721("the Plug", "") {}


	/*** CORE FUNCTIONS ***/

	// @dev Override 'tokenURI' to account for asset/hash cycling
	function tokenURI(uint256 tokenId) public view virtual override returns (string memory) 
	{	
		require(_exists(tokenId), "Plug (ERC721Metadata): URI query for nonexistent token");

		string memory baseURI = _baseURI();
		string memory hash = _tokenHash(tokenId);
		
		return string(abi.encodePacked(baseURI, hash));
	}

	// @dev All of the asset's will be pinned to IPFS
	function _baseURI() internal view virtual returns (string memory)
	{
		return "https://ipfs.io/ipfs/";
	}

	// @dev Based on the number of days that have passed since the last transfer of
	// ownership, this function returns the appropriate IPFS hash
	function _tokenHash(uint256 tokenId) internal virtual view returns (string memory)
	{
		require(_exists(tokenId), "Plug (ERC721Metadata): URI query for nonexistent token");

		// TEST LOGIC 
		// Calculate the number of minutes that have passed for 'tokenId'
		uint minsPassed = countMinutesPassed(tokenId);
		// Order is "reversed" for cleaner code
		if (minsPassed >= 45) {
			return HASH_7;
		} else if (minsPassed >= 30) {
			return HASH_6;
		} else if (minsPassed >= 25) {
			return HASH_5;
		} else if (minsPassed >= 20) {
			return HASH_4;
		} else if (minsPassed >= 15) {
			return HASH_3;
		} else if (minsPassed >= 10) {
			return HASH_2;
		} else if (minsPassed >= 5) {
			return HASH_1;
		} else {
			return HASH_0; 
		}
	}

	// @dev Any Plug transfer this will be called beforehand (updating the transfer time)
	// If a Plug is now a Grandfather, it's timestamp won't be updated so its	
	function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual override
    {	
    	// If the "4 years" have passed, don't change birthday
    	if (_exists(tokenId) && !isAlchemist(tokenId)) {
    		_setBirthday(tokenId);
    	}
    }


    // @dev Mint a single Plug
	function mintPlug(address recipient) public onlyOwner returns (uint256)
	{
		_tokenIds.increment();

		uint256 newId = _tokenIds.current();
		_safeMint(recipient, newId);
		_setBirthday(newId); //setup this token & its "birthday"

		return newId;
	}

	// @dev Burn a single Plug (destroy forever)
	function burnPlug(uint256 tokenId) public virtual isSquad
	{
		require(_isApprovedOrOwner(_msgSender(), tokenId), "Burnable: caller is not approved to burn");

		_burn(tokenId);
	}


	/*** "THE PLUG" FUNCTIONS 
		 & PUBLIC FACING FUNCTIONS FOR CHANGES **/

	// @dev Get the last transfer time for a tokenId
	function getBirthday(uint256 tokenId) public view returns (uint)
	{
		return _birthdays[tokenId];
	}

	// @dev Determine if a token has reached alchemist status
	function isAlchemist(uint256 tokenId) public view returns (bool)
	{
		return countMinutesPassed(tokenId) >= 45;//testing
		//return countDaysPassed(tokenId) >= 1440;
	}

	// @dev List the owners for a certain level (determined by _assetHash)
	// We'll need this for airdrops and benefits
	function listLevelOwners(string memory _assetHash) public view isSquad returns (address[] memory)
	{
		require(_hashExists(_assetHash), "Plug (ERC721Metadata): IPFS hash nonexistent");

		address[] memory levelOwners = new address[](MAX_NUM_PLUGS);
		uint counter = 0;

		// Go thru list of created token id's (existing Plugs) so far
		uint tokenId;
		uint lastTokenId = _tokenIds.current();
		for (tokenId = 1; tokenId <= lastTokenId; tokenId++) {

			// Find the IPFS hash associated with this token ID
			string memory hash = _tokenHash(tokenId);

			// If this is equal to the hash we're looking for (assetHash)
			// then determine the owner of the token and add it to our list
			if (_stringsEqual(hash, _assetHash)) {
				address owner = ownerOf(tokenId);
				levelOwners[counter] = owner;
				counter++;
			}
		}

		return levelOwners;
	}

	// @dev Allows us to update the IPFS hash values
	function updateHash(uint8 _hash_num, string memory _str) public isSquad {
		require(0 <= _hash_num && _hash_num < NUM_ASSETS, 
			"PlugStorage: _hash_num out of bounds");
		// Can only update one hash at a time...
		assetHashes[_hash_num] = _str;
	}


	/*** HELPER FUNCTIONS ***/

	// @dev Determine if 'assetHash' is one of the IPFS hashes for Plug
	function _hashExists(string memory _assetHash) internal view returns (bool) 
	{
		uint8 i;
		for (i = 0; i < NUM_ASSETS; i++) {
			if (!_stringsEqual(_assetHash, assetHashes[i])) {
				return false;
			}
		}
		return true;
	}

	// @dev Set the last transfer time for a tokenId
	function _setBirthday(uint256 tokenId) private
	{
		_birthdays[tokenId] = block.timestamp;
	}


	/****** TIME SHIT ******/

	// Number of minutes that have passed since transfer/mint
	function countMinutesPassed(uint256 tokenId) public view returns (uint16) 
	{
	    require(_exists(tokenId), 
	    	"Plug (ERC721Metadata): time (minutes) query for nonexistent token");
		return uint16((block.timestamp - _birthdays[tokenId]) / 1 minutes);
	}

	// Number of hours that have passed since transfer/mint
	function countHoursPassed(uint256 tokenId) public view returns (uint16) 
	{
		require(_exists(tokenId), 
			"Plug (ERC721Metadata): time (hours) query for nonexistent token");
		return uint16((block.timestamp - _birthdays[tokenId]) / 1 hours);
	}

	// Number of days that have passed since transfer/mint
	function countDaysPassed(uint256 tokenId) public view returns (uint16) 
	{
		require(_exists(tokenId), 
			"Plug (ERC721Metadata): time (days) query for nonexistent token");
		return uint16((block.timestamp - _birthdays[tokenId]) / 1 days);
	}
}

/*
// @dev Based on the number of days that have passed since the last transfer of
// ownership, this function returns the appropriate IPFS hash
function _tokenHash(uint256 tokenId) internal virtual view returns (string memory)
{
	require(_exists(tokenId), "Plug (ERC721Metadata): URI query for nonexistent token");

	// PRODUCTION LOGIC ///////////////////////////////////////////////////////
	// Calculate days gone by for this particular token with 'tokenId'
	// uint daysPassed = (block.timestamp - _lastTransferTimes[tokenId]) / 1 days;
	// // The logic here is "reversed" for cleaner code
	if (daysPassed >= 1440) {
	 return HASH_7;
	} else if (daysPassed >= 360) {
		return HASH_6;
	} else if (daysPassed >= 300) {
		return HASH_5;
	} else if (daysPassed >= 240) {
		return HASH_4;
	} else if (daysPassed >= 180) {
		return HASH_3;
	} else if (daysPassed >= 120) {
		return HASH_2;
	} else if (daysPassed >= 60) {
		return HASH_1;
	} else { //if 60 days haven't passed, the initial asset/Plug is returned
		return HASH_0; 
	}
}
*/
