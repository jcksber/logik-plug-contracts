// SPDX-License-Identifier: MIT
/*
 * Plug.sol
 *
 * Author: Jack Kasbeer
 * Created: August 3, 2021
 *
 * Price: 0.0888 ETH
 *
 * Description: An ERC-721 token that will change based on (1) time held by a single owner and
 * 				(2) trades between owners; the different versions give you access to airdrops.
 *
 *  - As long as the owner remains the same, every 60 days, the asset will acquire more "juice" 
 * 	  not only updating the asset, but allowing the owner to receive more airdrops from other 
 *    artists.  This means after a year, the final asset (and most valuable) will now be in the 
 *    owner's wallet (naturally each time, the previous asset is replaced).
 *  - If the NFT changes owners, the initial/day 0 asset is now what will be seen by the owner,
 *    and they'll have to wait a full cycle "final asset status" (gold)
 *  - If a Plug is a Alchemist (final state), it means that it will never lose juice again,
 *    even if it is transferred.
 *
 */

pragma solidity >=0.5.16 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "./Kasbeer721.sol";

//@title The Plug
//@author Jack Kasbeer (gh:@jcksber, tw:@satoshigoat)
contract Plug is Kasbeer721 {

	using Counters for Counters.Counter;
	using SafeMath for uint256;

	//@dev Emitted when token is transferred
	event PlugTransferred(address indexed from, address indexed to);

	//@dev How we keep track of how many days a person has held a Plug
	mapping(uint256 => uint) internal _birthdays; //tokenID -> UTCTime

	constructor() Kasbeer721("the minute Plug", "") {
		// Add LOGIK's dev address
		addToSquad(0x6b8C6E15818C74895c31A1C91390b3d42B336799);
		whitelistActive = true;
		contractUri = "ipfs://QmW94EMoXifmMPiEkHEbFyDYiVxX8K4Trq3R4pYemSx4EK";
	}

	// -----------
	// RESTRICTORS
	// -----------

	modifier batchLimit(uint8 _numToMint)
	{
		require(1 <= _numToMint && _numToMint <= 8, "Plug: mint between 1 and 8");
		_;
	}

	modifier plugsAvailable(uint256 _numToMint)
	{
		require(_tokenIds.current() + _numToMint <= MAX_NUM_TOKENS, 
			"Plug: not enough Plugs remaining to mint");
		_;
	}

	modifier tokenExists(uint256 tokenId)
	{
		require(_exists(tokenId), "Plug: nonexistent token");
		_;
	}

	// ----------
	// PLUG MAGIC
	// ----------

	//@dev Override 'tokenURI' to account for asset/hash cycling
	function tokenURI(uint256 tokenId) 
		tokenExists(tokenId) public view virtual override returns (string memory) 
	{	
		string memory baseURI = _baseURI();
		string memory hash = _tokenHash(tokenId);
		
		return string(abi.encodePacked(baseURI, hash));
	}

	//@dev Based on the number of days that have passed since the last transfer of
	// ownership, this function returns the appropriate IPFS hash
	function _tokenHash(uint256 tokenId) 
		internal virtual view 
		returns (string memory)
	{
		if (!_exists(tokenId)) {
			return "";//not a require statement to avoid errors being thrown
		}

		// Calculate days gone by for this particular token 
		uint daysPassed = countMinutesPassed(tokenId);//NOTE: CHANGE FOR PRODUCTION!

		// Based on the number of days that have gone by, return the appropriate state of the Plug
		if (daysPassed >= 557) {
			if (tokenId <= 176) {
				return chiHashes[7];
			} else if (tokenId % 88 == 0) {
				return stlHashes[7];
			} else {
				return normHashes[7];
			}
		} else if (daysPassed >= 360) {
			if (tokenId <= 176) {
				return chiHashes[6];
			} else if (tokenId % 88 == 0) {
				return stlHashes[6];
			} else {
				return normHashes[6];
			}
		} else if (daysPassed >= 300) {
			if (tokenId <= 176) {
				return chiHashes[5];
			} else if (tokenId % 88 == 0) {
				return stlHashes[5];
			} else {
				return normHashes[5];
			}
		} else if (daysPassed >= 240) {
			if (tokenId <= 176) {
				return chiHashes[4];
			} else if (tokenId % 88 == 0) {
				return stlHashes[4];
			} else {
				return normHashes[4];
			}
		} else if (daysPassed >= 180) {
			if (tokenId <= 176) {
				return chiHashes[3];
			} else if (tokenId % 88 == 0) {
				return stlHashes[3];
			} else {
				return normHashes[3];
			}
		} else if (daysPassed >= 120) {
			if (tokenId <= 176) {
				return chiHashes[2];
			} else if (tokenId % 88 == 0) {
				return stlHashes[2];
			} else {
				return normHashes[2];
			}
		} else if (daysPassed >= 60) {
			if (tokenId <= 176) {
				return chiHashes[1];
			} else if (tokenId % 88 == 0) {
				return stlHashes[1];
			} else {
				return normHashes[1];
			}
		} else { //if 60 days haven't passed, the initial asset/Plug is returned
			if (tokenId <= 176) {
				return chiHashes[0];
			} else if (tokenId % 88 == 0) {
				return stlHashes[0];
			} else {
				return normHashes[0];
			}
		}
	}

	//@dev Any Plug transfer this will be called beforehand (updating the transfer time)
	// If a Plug is now an Alchemist, it's timestamp won't be updated so that it never loses juice
	function _beforeTokenTransfer(address from, address to, uint256 tokenId) 
		internal virtual override
    {
    	// If the "1.5 years" have passed, don't change birthday
    	if (_exists(tokenId) && countMinutesPassed(tokenId) < 557) {//NOTE: change for prod!
    		_setBirthday(tokenId);
    	}
    	emit PlugTransferred(from, to);
    }

    //@dev Set the last transfer time for a tokenId
	function _setBirthday(uint256 tokenId) 
		private
	{
		_birthdays[tokenId] = block.timestamp;
	}

	//@dev List the owners for a certain level (determined by _assetHash)
	// We'll need this for airdrops and benefits
	function listPlugOwners(string memory _assetHash) 
		isSquad public view returns (address[] memory)
	{
		require(_hashExists(_assetHash), "Plug: nonexistent hash");

		address[] memory levelOwners = new address[](MAX_NUM_PLUGS);

		uint16 tokenId, counter;
		for (tokenId = 1; tokenId <= _tokenIds.current(); tokenId++) {
			if (_stringsEqual(_tokenHash(tokenId), _assetHash)) {
				levelOwners[counter] = ownerOf(tokenId);
				counter++;
			}
		}
		return levelOwners;
	}

    // --------------------
    // MINTING & PURCHASING
    // --------------------

    //@dev Allows owners to mint for free
    function mint(address _to) 
    	isSquad public virtual override returns (uint256)
    {
    	return _mintInternal(_to);
    }

	//@dev Purchase & mint multiple Plugs
    function purchase(
    	address payable _to, 
    	uint256 _numToMint
    ) whitelistDisabled batchLimit(_numToMint) plugsAvailable(_numToMint)
      public payable 
      returns (bool)
    {
    	require(msg.value >= _numToMint * TOKEN_WEI_PRICE, "Plug: not enough ether");
    	//send change if too much was sent
        if (msg.value > 0) {
	    	uint256 diff = msg.value.sub(TOKEN_WEI_PRICE * _numToMint);
    		if (diff > 0) {
    	    	_to.transfer(diff);
    		}
      	}
    	uint8 i;//mint `_num` Plugs to address `_to`
    	for (i = 0; i < _numToMint; i++) {
    		_mintInternal(_to);
    	}
    	return true;
    }

    //@dev A whitelist controlled version of `purchaseMultiple`
    function whitelistPurchase(
    	address payable _to, 
    	uint256 _numToMint
    ) whitelistEnabled onlyWhitelist(_to) batchLimit(_numToMint) plugsAvailable(_numToMint)
      public payable 
      returns (bool)
    {
    	require(msg.value >= _numToMint * TOKEN_WEI_PRICE, "Plug: not enough ether");
    	//send change if too much was sent
        if (msg.value > 0) {
	    	uint256 diff = msg.value.sub(TOKEN_WEI_PRICE * _numToMint);
    		if (diff > 0) {
    	    	_to.transfer(diff);
    		}
      	}
    	uint8 i;//mint `_num` Plugs to address `_to`
    	for (i = 0; i < _numToMint; i++) {
    		_mintInternal(_to);
    	}
    	return true;
    }

	//@dev Mints a single Plug & sets up the initial birthday 
	function _mintInternal(address _to) 
		plugsAvailable(1) internal virtual returns (uint256)
	{
		_tokenIds.increment();
		uint256 newId = _tokenIds.current();
		_safeMint(_to, newId);
		_setBirthday(newId);
		emit ERC721Minted(newId);

		return newId;
	}
	
	// ----
	// TIME
	// ----

	//@dev Retuns number of minutes that have passed since transfer/mint
	function countMinutesPassed(uint256 tokenId) 
		tokenExists(tokenId) public view returns (uint256) 
	{
		return uint256((block.timestamp - _birthdays[tokenId]) / 1 minutes);
	}

	//@dev Returns number of days that have passed since transfer/mint
	function countDaysPassed(uint256 tokenId) 
		tokenExists(tokenId) public view returns (uint256) 
	{
		return uint256((block.timestamp - _birthdays[tokenId]) / 1 days);
	}
}
