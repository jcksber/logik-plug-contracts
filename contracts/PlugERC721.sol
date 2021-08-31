// SPDX-License-Identifier: MIT
/*
 * BACKUP/FLATTENED Plug.sol
 *
 * Author: Jack Kasbeer
 * Created: August 30, 2021
 *
 * Price: ~0.1 ETH
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
 *				   8. 48 months (1440 days): Permanent 100% (alchemist)
 *  - If a Plug is a Alchemist (final state), it means that it will never lose juice again,
 *    even if it is transferred.
 */

pragma solidity >=0.5.16 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract ThePlug is ERC721, Ownable {

	/*** STORAGE ***/

	//@dev Emitted when someone is added to `_squad`
	event SquadMemberAdded(address indexed member);
	//@dev Emitted when someone is removed from `_squad`
	event SquadMemberRemoved(address indexed member);
	//@dev Emitted when a token is minted
	event ERC721Minted(uint256 indexed tokenId);
	//@dev Emitted when a token is burned
	event ERC721Burned(uint256 indexed tokenId);
	//@dev Emitted when an ipfs hash is updated
	event HashUpdated(string indexed newHash);

	using Counters for Counters.Counter;
	Counters.Counter internal _tokenIds;

	//@dev Ownership
	mapping (address => bool) internal _squad;
	//@dev Keep track of the birthday (mint/last transfer) for each token ID
	mapping(uint256 => uint) internal _birthdays; //tokenID -> UTCTime
	//@dev Important numbers
	uint constant NUM_ASSETS = 8;
	uint constant MAX_NUM_PLUGS = 888;
	//@dev Production hashes
	string internal HASH_0 = "QmSJQmBV5crGcmq54WUB22SRw9SGsp1YSaxfenQEbZ5qTD"; //1% Plug
	string internal HASH_1 = "QmY7HTXyHk4UQUr8PUQC3rUQD9fFa8dVutyRBZSdorWhMv";
	string internal HASH_2 = "QmSUTwTS3aALgZHyuvYV1ys3d5FHbeJ24MDTfA4WCkncop";
	string internal HASH_3 = "QmcciA32wMXVJpGQCyAumXSa9QT7FKvh1tDBgYxELm7THu";
	string internal HASH_4 = "QmSfr7uuVjm4ddzYkwR1bD1u8KRSueSfKYx7w3tGjstcgt";
	string internal HASH_5 = "QmUm9aTEEBgQTSpE24Q1fCHeBzntAd9nguJLFDFkSjmNPv";
	string internal HASH_6 = "QmUBsLHrMFLUjApCrnd8DUjk2noe52gN48JHUF1WTCuw6b"; //100% Plug
	string internal HASH_7 = "QmPqezAYfYy1pjdi3MstdnT1F9NAmvcqtvrFpY7o6HGTRE"; //alchemist Plug
	//@dev Our list of IPFS hashes for each of the 8 Plugs (varying juice levels)
	string [NUM_ASSETS] assetHashes = [HASH_0, HASH_1, 
									   HASH_2, HASH_3, 
									   HASH_4, HASH_5, 
									   HASH_6, HASH_7];


	/*** CONSTRUCTION ***/

	//@dev Create Plug
	constructor() ERC721("the Plug v12", "") {
		// Add my personal dev address
		address me = 0xEAb4Aea5cD7376C04923236c504e7e91362566D1;
		addToSquad(me);
		// Add LOGIK's dev address
		address logik = 0x6b8C6E15818C74895c31A1C91390b3d42B336799;
		addToSquad(logik);
	}


	/*** ERC721 FUNCTIONS / CORE FUNCTIONS ***/

	//@dev Override 'tokenURI' to account for asset/hash cycling
	function tokenURI(uint256 tokenId) public view virtual override returns (string memory) 
	{	
		require(_exists(tokenId), 
			"KasbeerMade721 (ERC721Metadata): URI query for nonexistent token");

		string memory baseURI = _baseURI();
		string memory hash = _tokenHash(tokenId);
		
		return string(abi.encodePacked(baseURI, hash));
	}

	//@dev All of the asset's will be pinned to IPFS
	function _baseURI() internal view virtual override returns (string memory)
	{
		return "https://ipfs.io/ipfs/";
	}

	//@dev Based on the number of days that have passed since the last transfer of
	// ownership, this function returns the appropriate IPFS hash
	function _tokenHash(uint256 tokenId) internal virtual view returns (string memory)
	{
		require(_exists(tokenId), "Plug (ERC721Metadata): URI query for nonexistent token");

		// TEST LOGIC 
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
		
		// Calculate days gone by for this particular token with 'tokenId'
		//uint daysPassed = (block.timestamp - _birthdays[tokenId]) / 1 days;
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

	//@dev Determine if '_assetHash' is one of the IPFS hashes in assetHashes
	function _hashExists(string memory _assetHash) internal view returns (bool) 
	{
		// uint numAssets = _hashIds.current();
		uint8 i;
		for (i = 0; i < NUM_ASSETS; i++) {
			if (_stringsEqual(_assetHash, assetHashes[i])) {
				return true;
			}
		}

		return false;
	}

	//@dev Allows us to update the IPFS hash values (one at a time)
	function updateHash(uint8 _hash_num, string memory _str) public isSquad 
	{
		require(0 <= _hash_num && _hash_num < NUM_ASSETS, 
			"KasbeerMade721: _hash_num out of bounds");

		assetHashes[_hash_num] = _str;
		emit HashUpdated(_str);
	}

	//@dev Get the hash stored at assetHashes[idx]
	function getHashByIndex(uint256 idx) public view returns (string memory)
	{
		require(0 <= idx && idx < NUM_ASSETS, 
			"KasbeerMade721: index out of bounds");
		
		return assetHashes[idx];
	}

	//@dev Any Plug transfer this will be called beforehand (updating the transfer time)
	// If a Plug is now an Alchemist, it's timestamp won't be updated so that it never loses juice
	function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual override
    {	
    	// If the "4 years" have passed, don't change birthday
    	if (_exists(tokenId) && !isAlchemist(tokenId)) {
    		_setBirthday(tokenId);
    	}
    }

	//@dev Custom mint function - nothing special 
	function mint721(address recipient) public onlyOwner returns (uint256)
	{
		_tokenIds.increment();

		uint256 newId = _tokenIds.current();
		_safeMint(recipient, newId);
		_setBirthday(newId); //setup this token & its "birthday"
		emit ERC721Minted(newId);

		return newId;
	}

	//@dev Custom burn function - nothing special
	function burn721(uint256 tokenId) public isSquad
	{
		_burn(tokenId);
		emit ERC721Burned(tokenId);
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
		return countMinutesPassed(tokenId) >= 45;//testing
		//return countDaysPassed(tokenId) >= 1440;
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


	/*** OWNERSHIP ***/

	//@dev Custom "approved" modifier because I don't like that language
	modifier isSquad()
	{
		require(isInSquad(msg.sender), "KasbeerMade721: Caller not part of squad.");
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
		require(!isInSquad(a), "KasbeerMade721: Address already in squad.");

		_squad[a] = true;
		emit SquadMemberAdded(a);
	}

	//@dev Remove someone from the squad
	function removeFromSquad(address a) public onlyOwner
	{
		require(isInSquad(a), "KasbeerMade721: Address already not in squad.");

		_squad[a] = false;
		emit SquadMemberRemoved(a);
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

	//@dev This function doesn't work, not exactly sure why
	function kill() public onlyOwner
	{
		selfdestruct(payable(owner()));
	}

	//@dev Returns the most recently minted token id 
	function getCurrentTokenId() public view returns (uint256)
	{
		return _tokenIds.current();
	}

	//@dev Determine if a token exists 
	function tokenExists(uint256 tokenId) public view returns (bool)
	{
		return _exists(tokenId);
	}

	//@dev Determine if two strings are equal using the length + hash method
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
}














