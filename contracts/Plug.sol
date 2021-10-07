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
 *				   8. 18 months (557 days): Permanent 100% (alchemist)
 *  - If a Plug is a Alchemist (final state), it means that it will never lose juice again,
 *    even if it is transferred.
 *
 *  St. Louis ID's: 264, 352, 440, 528, 616, 704, 792, 880
 */

pragma solidity >=0.5.16 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "./KasbeerMade721.sol";
import "./KasbeerStorage.sol";

//@title The Plug
//@author Jack Kasbeer (gh:@jcksber, tw:@satoshigoat)
contract Plug is KasbeerMade721 {

	uint constant MAX_NUM_PLUGS = 888;

	using Counters for Counters.Counter;
	mapping(uint256 => uint) internal _birthdays; //tokenID -> UTCTime

	//@dev Create Plug
	constructor() KasbeerMade721("The Plug", "") {
		// Add LOGIK's dev address
		address logik = 0x6b8C6E15818C74895c31A1C91390b3d42B336799;
		addToSquad(logik);
	}


	/*** CORE FUNCTIONS ***/

	//@dev Based on the number of days that have passed since the last transfer of
	// ownership, this function returns the appropriate IPFS hash
	function _tokenHash(uint256 tokenId) internal virtual view override returns (string memory)
	{
		if (!_exists(tokenId)) {
			return "";//not a require statement to avoid errors being thrown
		}

		// Calculate days gone by for this particular token 
		uint daysPassed = (block.timestamp - _birthdays[tokenId]) / 1 days;

		// Based on the number of days that have gone by, return the appropriate state of the Plug
		if (daysPassed >= 557) {
			if (tokenId <= 176) {
				return CHASH_7;
			} else if (tokenId % 88 == 0) {
				return LHASH_7;
			} else {
				return NHASH_7;
			}
		} else if (daysPassed >= 360) {
			if (tokenId <= 176) {
				return CHASH_6;
			} else if (tokenId % 88 == 0) {
				return LHASH_6;
			} else {
				return NHASH_6;
			}
		} else if (daysPassed >= 300) {
			if (tokenId <= 176) {
				return CHASH_5;
			} else if (tokenId % 88 == 0) {
				return LHASH_5;
			} else {
				return NHASH_5;
			}
		} else if (daysPassed >= 240) {
			if (tokenId <= 176) {
				return CHASH_4;
			} else if (tokenId % 88 == 0) {
				return LHASH_4;
			} else {
				return NHASH_4;
			}
		} else if (daysPassed >= 180) {
			if (tokenId <= 176) {
				return CHASH_3;
			} else if (tokenId % 88 == 0) {
				return LHASH_3;
			} else {
				return NHASH_3;
			}
		} else if (daysPassed >= 120) {
			if (tokenId <= 176) {
				return CHASH_2;
			} else if (tokenId % 88 == 0) {
				return LHASH_2;
			} else {
				return NHASH_2;
			}
		} else if (daysPassed >= 60) {
			if (tokenId <= 176) {
				return CHASH_1;
			} else if (tokenId % 88 == 0) {
				return LHASH_1;
			} else {
				return NHASH_1;
			}
		} else { //if 60 days haven't passed, the initial asset/Plug is returned
			if (tokenId <= 176) {
				return CHASH_0;
			} else if (tokenId % 88 == 0) {
				return LHASH_0;
			} else {
				return NHASH_0;
			}
		}
	}

	//@dev Any Plug transfer this will be called beforehand (updating the transfer time)
	// If a Plug is now an Alchemist, it's timestamp won't be updated so that it never loses juice
	function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual override
    {
    	// If the "1.5 years" have passed, don't change birthday
    	if (_exists(tokenId) && !isAlchemist(tokenId)) {
    		_setBirthday(tokenId);
    	}
    }


    //@dev Mint a single Plug
	function mint721(address recipient) public virtual override returns (uint256)
	{
		require(_tokenIds.current() < MAX_NUM_PLUGS, "Plug: all plugs have been minted");

		_tokenIds.increment();

		uint256 newId = _tokenIds.current();
		_safeMint(recipient, newId);
		_setBirthday(newId); //setup this token & its "birthday"
		emit ERC721Minted(newId);

		return newId;
	}


	/*** "THE PLUG" FUNCTIONS 
		 & PUBLIC FACING FUNCTIONS FOR CHANGES **/

	//@dev Get the last transfer time for a tokenId
	function getBirthday(uint256 tokenId) public view returns (uint)
	{
		require(_exists(tokenId), 
			"Plug (ERC721Metadata): URI query for nonexistent token");

		return _birthdays[tokenId];
	}

	//@dev Determine if a token has reached alchemist status
	function isAlchemist(uint256 tokenId) public view returns (bool)
	{
		require(_exists(tokenId), 
			"Plug (ERC721Metadata): Alchemist query for nonexistent token");

		return countDaysPassed(tokenId) >= 557;
	}

	//@dev List the owners for a certain level (determined by _assetHash)
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


	/*** HELPER FUNCTIONS ***/

	//@dev Set the last transfer time for a tokenId
	function _setBirthday(uint256 tokenId) private
	{
		_birthdays[tokenId] = block.timestamp;
	}

	//@dev Retuns number of minutes that have passed since transfer/mint
	function countMinutesPassed(uint256 tokenId) public view returns (uint256) 
	{
	    require(_exists(tokenId), 
	    	"Plug (ERC721Metadata): time (minutes) query for nonexistent token");

		return uint256((block.timestamp - _birthdays[tokenId]) / 1 minutes);
	}

	//@dev Returns number of hours that have passed since transfer/mint
	function countHoursPassed(uint256 tokenId) public view returns (uint256) 
	{
		require(_exists(tokenId), 
			"Plug (ERC721Metadata): time (hours) query for nonexistent token");

		return uint256((block.timestamp - _birthdays[tokenId]) / 1 hours);
	}

	//@dev Returns number of days that have passed since transfer/mint
	function countDaysPassed(uint256 tokenId) public view returns (uint256) 
	{
		require(_exists(tokenId), 
			"Plug (ERC721Metadata): time (days) query for nonexistent token");
		
		return uint256((block.timestamp - _birthdays[tokenId]) / 1 days);
	}
}
