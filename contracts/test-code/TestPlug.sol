// // SPDX-License-Identifier: MIT
// pragma solidity >=0.4.23 <0.9.0;

// import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
// import "@openzeppelin/contracts/utils/Counters.sol";
// import "@openzeppelin/contracts/access/Ownable.sol";

// contract TestPlug is ERC721, Ownable {
//     using Counters for Counters.Counter;
// 	Counters.Counter private _tokenIds;
	
//     uint constant NUM_ASSETS = 7;
//     uint constant MAX_NUM_PLUGS = 10;
    
// 	// Production hashes
// 	string constant HASH_0 = "Qmf17yfaQsBmZkyVfc3JfiSqGifN5VQaKJmTGdQnAuAkmE"; //1% Plug
// 	string constant HASH_1 = "QmemZy6Ysr4tafv6F7Xm613ACgpr9LscrGNCqh67dcV8fS";
// 	string constant HASH_2 = "QmXdnXnHKQ4piXKv1aRkdy9BhuxQWBFcZjR6RcyHXhq6N2";
// 	string constant HASH_3 = "Qmd8HyLnhvZbAVNqPMcah6bYHLVcc9Aumhohpr7azcuTP4";
// 	string constant HASH_4 = "QmbKYkSBuencis49GjKqCc4jPWyCRpHsmA1JtqWBoiLojf";
// 	string constant HASH_5 = "QmShxEMhMSanqYLV2dhweivjyrVbdVLDpP5QhJ7cmbCwEK";
// 	string constant HASH_6 = "QmYg1u1b39nWbv4TcsxU4Jgrv8qwsDzUiuShmi1RiU5t98"; //100% Plug
	
// 	string[NUM_ASSETS] _assetHashes = [HASH_0, HASH_1, HASH_2, HASH_3, HASH_4, HASH_5, HASH_6];
	
// 	mapping(uint256 => uint) private _lastTransferTimes;
	
// 	// Create Plug
// 	constructor() ERC721("LOGIK: Plug", "") {}
	
// 	// TRANSFER FUNCTIONS
// // 	function transferFrom(address from, address to, uint256 tokenId) public virtual override
// // 	{
// // 		require(_isApprovedOrOwner(_msgSender(), tokenId), "Plug (ERC721): caller not owner or approved");

// // 		_lastTransferTimes[tokenId] = block.timestamp;
// // 		transferFrom(from, to, tokenId);
// // 	}
// // 	function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override 
// // 	{
// // 		require(_exists(tokenId), "Plug (ERC721Metadata): transfer attempt for nonexistent token");
		
// // 		_lastTransferTimes[tokenId] = block.timestamp;
// // 		safeTransferFrom(from, to, tokenId, "");
// // 	}
// // 	function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) 
// // 	public virtual override
// // 	{
// // 		require(_isApprovedOrOwner(_msgSender(), tokenId), "Plug (ERC721): caller not owner or approved");

// // 		_lastTransferTimes[tokenId] = block.timestamp;
// // 		_safeTransfer(from, to, tokenId, _data);
// // 	}
//     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual override
//     {
//         _lastTransferTimes[tokenId] = block.timestamp;
//     }
	
// 	// MINT & BURN
// 	function mintPlug(address recipient) public onlyOwner returns (uint256)
// 	{
// 		_tokenIds.increment();

// 		uint256 newId = _tokenIds.current();
// 		_safeMint(recipient, newId);
		
// 		// Add this to our mapping of "last transfer times"
// 		_lastTransferTimes[newId] = block.timestamp;

// 		return newId;
// 	}
// 	function burnPlug(uint256 tokenId) public virtual 
// 	{
// 		require(_isApprovedOrOwner(_msgSender(), tokenId), "Burnable: caller is not approved to burn");
		
// 		//don't actually know if this works yet.. prolly doesn't
// 		_burn(tokenId);
// 	}
	
// 	// OTHER FUNCTIONS
// 	// Override 'tokenURI' to account for asset/hash cycling
// 	function tokenURI(uint256 tokenId) public view virtual override returns (string memory) 
// 	{	
// 		require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");

// 		string memory baseURI = _baseURI();
// 		string memory hash = _tokenHash(tokenId);
		
// 		return string(abi.encodePacked(baseURI, hash));
// 	}
// 	// List the owners for a certain level (determined by assetHash)
// 	// We'll need this for airdrops and benefits
// 	function listLevelOwners(string memory assetHash) public view returns (address[] memory)
// 	{
// 		require(_hashExists(assetHash), "ERC721Metadata: IPFS hash nonexistent");
        
// 		address[] memory levelOwners = new address[](MAX_NUM_PLUGS);
		
// 		uint lastTokenId = _tokenIds.current();
// 		uint counter = 0; //keeps track of where we are in 'owners'

// 		// Go thru list of created token id's (existing Plugs) so far
// 		uint tokenId;
// 		for (tokenId = 1; tokenId <= lastTokenId; tokenId++) {

// 			// Find the IPFS hash associated with this token ID
// 			string memory hash = _tokenHash(tokenId);

// 			// If this is equal to the hash we're looking for (assetHash)
// 			// then determine the owner of the token and add it to our list
// 			if (_stringsEqual(hash, assetHash)) {
// 				address owner = ownerOf(tokenId);
// 				levelOwners[counter] = owner;
// 				counter++;
// 			}
// 		}

// 		return levelOwners;
// 	}
// 	// IPFS hash exists?
// 	function testHashExists(string memory hash) public pure returns (bool) 
// 	{
// 	    return _hashExists(hash);
// 	}
// 	// Minutes?
// 	function minutesPassed(uint256 tokenId) public view returns (uint) 
// 	{
// 	    require(_exists(tokenId), "ERC721Metadata: time (minutes) query for nonexistent token");
// 		return uint8((block.timestamp - _lastTransferTimes[tokenId]) / 1 minutes);
// 	}
// 	// Hours?
// 	function countHoursPassed(uint256 tokenId) public view returns (uint16) 
// 	{
// 	    require(_exists(tokenId), "ERC721Metadata: time (hours) query for nonexistent token");
// 		return uint16((block.timestamp - _lastTransferTimes[tokenId]) / 1 hours);
// 	}
//     // Days?
// 	function countDaysPassed(uint256 tokenId) public view returns (uint16) 
// 	{
// 	    require(_exists(tokenId), "ERC721Metadata: time (days) query for nonexistent token");
// 		return uint16((block.timestamp - _lastTransferTimes[tokenId]) / 1 days);
// 	}
	
	
// 	// HELPER FUNCTIONS
// 	function _baseURI() internal view virtual override returns (string memory)
// 	{
// 		return "https://ipfs.io/ipfs/";
// 	}

// 	function _tokenHash(uint256 tokenId) internal view virtual returns (string memory)
// 	{
// 		require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
		
// 		// TEST LOGIC /////////////////////////////////////////////////////////////
		
// 		// Calculate the number of hours that have passed for 'tokenId'
// 		uint hoursPassed = countHoursPassed(tokenId);
		
// 		// Order "reversed" for cleaner code
// 		if (hoursPassed >= 12) {
// 			return HASH_6;
// 		} else if (hoursPassed >= 10) {
// 			return HASH_5;
// 		} else if (hoursPassed >= 8) {
// 			return HASH_4;
// 		} else if (hoursPassed >= 6) {
// 			return HASH_3;
// 		} else if (hoursPassed >= 4) {
// 			return HASH_2;
// 		} else if (hoursPassed >= 2) {
// 			return HASH_1;
// 		} else {
// 			return HASH_0; 
// 		}
// 	}
    
//     // Determine if 'assetHash' is one of the IPFS hashes for Plug
// 	function _hashExists(string memory assetHash) internal pure returns (bool) 
// 	{
// 		return _stringsEqual(assetHash, HASH_0) || 
// 			   _stringsEqual(assetHash, HASH_1) ||
// 			   _stringsEqual(assetHash, HASH_2) ||
// 			   _stringsEqual(assetHash, HASH_3) ||
// 			   _stringsEqual(assetHash, HASH_4) ||
// 			   _stringsEqual(assetHash, HASH_5) ||
// 			   _stringsEqual(assetHash, HASH_6);
// 	}

// 	// Determine if two strings are equal using the length + hash method
// 	function _stringsEqual(string memory a, string memory b) internal pure returns (bool)
// 	{
// 		bytes memory A = bytes(a);
// 		bytes memory B = bytes(b);

// 		if (A.length != B.length) {
// 			return false;
// 		} else {
// 			return keccak256(A) == keccak256(B);
// 		}
// 	}
// }
