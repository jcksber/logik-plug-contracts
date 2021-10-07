// SPDX-License-Identifier: MIT
/*
 * KasbeerStorage.sol
 *
 * Author: Jack Kasbeer
 * Created: August 21, 2021
 */

pragma solidity >=0.5.16 <0.9.0;

import "@openzeppelin/contracts/utils/Counters.sol";

//@title The Plug storage contract
//@author Jack Kasbeer (@jcksber, @satoshigoat)
contract KasbeerStorage {

	//@dev Emitted when someone is added to `_squad`
	event SquadMemberAdded(address indexed member);
	//@dev Emitted when someone is removed from `_squad`
	event SquadMemberRemoved(address indexed member);
	//@dev Emitted when a token is minted
	event ERC721Minted(uint256 indexed tokenId);
	//@dev Emitted when a token is burned
	event ERC721Burned(uint256 indexed tokenId);
	//@dev Emitted when an ipfs hash is updated
	event HashUpdated(uint8 indexed group, string indexed newHash);

	//@dev These take care of token id incrementing
	using Counters for Counters.Counter;
	Counters.Counter internal _tokenIds;
	//@dev Ownership
	mapping (address => bool) internal _squad;
	//@dev Important numbers
	uint constant NUM_ASSETS = 8;
	//@dev Production hashes
	//Normal (non-chicago, non-st louis)
	string internal NHASH_0 = "QmPjFtabzu2mNEPE2Wxxt53iWPiCNEtNZW8LisoQRL61ii"; //1% Plug
	string internal NHASH_1 = "QmSK7ZkbCFPaGzf4NdcadZ8mPMn32qLSgWRyTHGPyV4rpM";
	string internal NHASH_2 = "Qmd2pWHx6j8fVW7jc3uWh3JcRZmo31D7MxfMSoJh73g7e9";
	string internal NHASH_3 = "QmT7ZyAcFn991g1TxqV9s4VyAC8Gfw5jaVsqwcpujHDLks";
	string internal NHASH_4 = "QmPJssrsJiycEs7UXMcSvg5uy93h2Jpc8i8KrQE1kjZXJt";
	string internal NHASH_5 = "QmYWiPGgQJrdgKJaJqrh1Y1VUu1WPw4yX9pEPCJm1RMKkB";
	string internal NHASH_6 = "QmQktmf4vVHb2waYfRNpcSj6DuTzkJgzTKByedqASxCMyV"; //100% Plug
	string internal NHASH_7 = "QmZm3FL4pWcBoVko9ZvWs6Sf8F4T7V9kHH5vsyVcLEr1AA"; //alchemist Plug
	//Chicago
	string internal CHASH_0 = "QmXHMtZSmLmFdHEewMAk53zMfoda1eT7uBB4g49nhfzWGi"; //1% Plug
	string internal CHASH_1 = "QmWat3juiFf5VAmUBtmcymdFrPsKde4Dn5RVFjDEL2DtBU";
	string internal CHASH_2 = "QmcdnbgWgQRymURhLshYm4hFNX3NnFmNWibfvG9qiSBtq4";
	string internal CHASH_3 = "QmcgvSDu2aZ3c7SwrXb6vC2fNQQAhsM9f1jTNbTdunKQmF";
	string internal CHASH_4 = "QmeuTccK5J9q96Rz2Lc62d7uCqhPwbW7e27KRCmDjAqpNn";
	string internal CHASH_5 = "Qmcrt2G19uNmRqN6rasfteoe5TaSoEw4RJBcnztchyixYS";
	string internal CHASH_6 = "QmPKJBx3BCHPFwfRrdyH4jXPKpmgPUTBRjD1ig9V8P7Agm"; //100% Plug
	string internal CHASH_7 = "QmPBSJucLXTMwyNGevtxiwDcZtmPt8yYdEv5xMryajw56n"; //alchemist Plug
	//St. Louis
	string internal LHASH_0 = "Qmf8MxmKwzdiESeCCUmchoPTKPAgbRgf25MH8DRMLasTwv"; //1% Plug
	string internal LHASH_1 = "QmUfq7b2A8kwbJv9wLKefUkSyDcGq7N4hWW6DERFuuiLRS";
	string internal LHASH_2 = "QmVq9JGEAn6J8Nwrx4roiDPkcMuYkLfGzZBjQDeZtcgP48";
	string internal LHASH_3 = "QmZD4BnkFmLX2tVdtpEh4Lj9VAN26TxB5ZfV53jGDKw2qF";
	string internal LHASH_4 = "QmZf619kVFEEQ6KU9kpvrMX6SVErTQb4UQkGEZB4je8Wx2";
	string internal LHASH_5 = "Qmb5rEtNkMzpionqa1syt9gJx5b3JoSijE82GWUoFECUHN";
	string internal LHASH_6 = "QmQKastBa7voNGsJah8HEo2PWzmq68bUp3mbYjCX3m7ydV"; //100% Plug
	string internal LHASH_7 = "Qmd87mFanJgibkgqXJkKrExQ1MXZdH9nVUaBGzfmEaR5M8"; //alchemist Plug

	//@dev Our list of IPFS hashes for each of the "normal" 8 Plugs (varying juice levels)
	string [NUM_ASSETS] normHashes = [NHASH_0, NHASH_1, 
									  NHASH_2, NHASH_3, 
									  NHASH_4, NHASH_5, 
									  NHASH_6, NHASH_7];
	//@dev Our list of IPFS hashes for each of the "Chicago" 8 Plugs (varying juice levels)
	string [NUM_ASSETS] chiHashes = [CHASH_0, CHASH_1,
								     CHASH_2, CHASH_3,
								     CHASH_4, CHASH_5,
								     CHASH_6, CHASH_7];
	//@dev Our list of IPFS hashes for each of the "Chicago" 8 Plugs (varying juice levels)
	string [NUM_ASSETS] stlHashes = [LHASH_0, LHASH_1,
								     LHASH_2, LHASH_3,
								     LHASH_4, LHASH_5,
								     LHASH_6, LHASH_7];
}



















