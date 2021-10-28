// SPDX-License-Identifier: MIT
/*
 * JuiceBox.sol
 *
 * Author: Jack Kasbeer
 * Created: October 27, 2021
 *
 * Price: 0.0888 ETH
 * Rinkeby:
 * Mainnet:
 *
 * Description: An ERC-721 token that will be claimable by anyone who owns 'the Plug'
 *
 *  - There will be 3 variations, each with a different rarity (based on how likely it is
 *    to receive)
 *  - Owners with multiple Plugs will be rewarded with a multiplier that will increase their
 *    chances of getting the rarer versions
 */

pragma solidity >=0.5.16 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "./JuiceBox721.sol";

//@title The Plug
//@author Jack Kasbeer (gh:@jcksber, tw:@satoshigoat)
contract Plug is Kasbeer721 {

	using Counters for Counters.Counter;
	using SafeMath for uint256;

	//@dev Emitted when token is transferred
	event PlugTransferred(address indexed from, address indexed to);

	//@dev This is how we'll keep track of who has already minted a JuiceBox
	mapping (address => bool) internal _boxHolders;
	//@dev Keep track of which token ID is associated with which hash
	mapping (uint256 => string) internal _tokenToHash;

	constructor() JuiceBox721("the Plug", "PLUG") {
		whitelist = true;//this list will be the list of Plug holders
		contractUri = "ipfs://";//NOTE: update for JuiceBox!
		payoutAddress = 0x6b8C6E15818C74895c31A1C91390b3d42B336799;//logik
		addToSquad(0xB9699469c0b4dD7B1Dda11dA7678Fa4eFD51211b);//add myself
		addToWhitelist(0xB9699469c0b4dD7B1Dda11dA7678Fa4eFD51211b);
	}

	// -----------
	// RESTRICTORS
	// -----------

	modifier boxAvailable()
	{
		require(_tokenIds.current() < MAX_NUM_TOKENS, "JuiceBox: no JuiceBox's left to mint");
		_;
	}

	modifier tokenExists(uint256 tokenId)
	{
		require(_exists(tokenId), "JuiceBox: nonexistent token");
		_;
	}

	// ---------------
	// JUICE BOX MAGIC 
	// ---------------

	//@dev Override 'tokenURI' to account for asset/hash cycling
	function tokenURI(uint256 tokenId) 
		tokenExists(tokenId) public view virtual override returns (string memory) 
	{	
		string memory baseURI = _baseURI();
		string memory hash = _tokenToHash[tokenId];
		
		return string(abi.encodePacked(baseURI, hash));
	}

	//@dev Based on the number of Plugs owned by the sender, randomly select 
	// a JuiceBox hash that will be associated with their token id
	function _assignHash(uint256 tokenId, uint16 numPlugs) tokenExists(tokenId) private
		returns (string memory)
	{
		uint16 i;
		string memory hash;
		uint16[] memory weights = new uint16[](NUM_ASSETS);
		//calculate new weights based on `numPlugs` 
		weights[0] = boxWeights[0] - numPlugs;
		weights[1] = boxWeights[1] + numPlugs;
		weights[2] = boxWeights[2] + numPlugs;//NOTE: apply SafeMath here instead!
		//(higher the weight => higher the probability)

		//uint16 sumWeights = weights[0] + weights[1] + weights[2];
		uint16 rnd = random() % MAX_NUM_TOKENS;//should be b/n 0 & MAX_NUM_TOKENS
		//randomly select a juice box hash
		for (i = 0; i < NUM_ASSETS; i++) {
			if (rnd < weights[i]) {
				hash = boxHashes[i];
				break;
			}
			rnd -= weights[i];
		}
		//assign the selected hash to this token id
		_tokenToHash[tokenId] = hash;
		
		return hash;
	}

	//@dev Update `_boxHolders` so that `a` cannot claim another juice box
	function _markAsClaimed(address a) private
	{
		_boxHolders[a] = true;
	}

    // ------------------
    // MINTING & CLAIMING
    // ------------------

    //@dev Allows owners to mint for free
    function mint(address to) isSquad boxAvailable public virtual override
    	returns (uint256 tid, string memory hash)
    {
    	tid = _mintInternal(to);
    	hash = _assignHash(tid, numPlugs);
    	return (tid, hash);
    }

    //@dev Claim a JuiceBox if you're a Plug holder
    function claim(address payable to, uint16 numPlugs) 
    	whitelistEnabled onlyWhitelist(to) boxAvailable public payable 
    	returns (bool)
    {
    	require(!_boxHolders[a], "JuiceBox: cannot claim more than 1");

    	uint256 tid = _mintInternal(to);
    	string memory hash = _assignHash(tid, numPlugs);
    	return _hashExists(hash);
    }

	//@dev Mints a single Plug & sets up the initial birthday 
	function _mintInternal(address to) 
		internal virtual returns (uint256)
	{
		_tokenIds.increment();
		uint256 newId = _tokenIds.current();
		_safeMint(to, newId);
		_markAsClaimed(to);//note that `to` has already minted a juice box
		emit JuiceBoxMinted(newId);

		return newId;
	}

	// ----------
	// RANDOM NUM
	// ----------

	//@dev Pseudo-random number generator
	function random() private view returns (uint)
	{
		return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, boxWeights)));
	}//NOTE: should we use boxWeights or something else...?
}
