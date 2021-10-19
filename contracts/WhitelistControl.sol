// SPDX-License-Identifier: MIT
/*
 * Verify.sol
 *
 * Author: Jack Kasbeer (taken from openzeppelin)
 * Created: October 15, 2021
 */

pragma solidity >=0.5.16 <0.9.0;

contract WhitelistControl {

	uint8 constant PRESALE_MAX = 200;
	mapping (address => bool) internal _whitelist;

	/*
	mapping hardcode for whitelist here
	*/

	modifier onlyValidAccess(address _addy)
	{
		require(isValidAccessData(_addy));
		_;
	}

	//@dev Prove that one of our whitelist address owners signed a message that included our
	// private key (string & int)
	function isValidAccessData(address _addy) public view returns (bool)
	//NOTE: maybe change these params we'll see
	{
		return _whitelist[_addy];
	}

	//@dev Recover the address that signed this message
	// function recoverSigner(bytes32 message, bytes memory sig) public pure returns (address)
	// {
	// 	uint8 v;
	// 	bytes32 r;
	// 	bytes32 s;

	// 	(v, r, s) = splitSignature(sig);

	// 	return ecrecover(message, v, r, s);
	// }

	// //@dev Obtain v, r, and s for a given signature
	// function splitSignature(bytes memory sig) public pure returns (uint8, bytes32, bytes32)
	// {
	// 	require(sig.length == 65);

	// 	bytes32 r;
	// 	bytes32 s;
	// 	uint8 v;

	// 	assembly {
	// 		//first 32 bytes, after the length prefix
	// 		r := mload(add(sig,32))
	// 		//second 32 bytes
	// 		s := mload(add(sig,64))
	// 		//final byte (first byte of the next 32 bytes)
	// 		v := byte(0, mload(add(sig,96)))
	// 	}

	// 	return (v,r,s);
	// }

	// // Builds a prefixed hash to mimic the behavior of eth_sign.
 //    function prefixed(bytes32 hash) internal pure returns (bytes32) {
 //        return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
 //    }
}
