// SPDX-License-Identifier: MIT
/*
 * Verify.sol
 *
 * Author: Jack Kasbeer (taken from openzeppelin)
 * Created: October 15, 2021
 */

pragma solidity >=0.5.16 <0.9.0;

contract Verify {

	uint8 constant PRESALE_MAX = 200;
	address[] whitelist = new address[](PRESALE_MAX);//fill this with addresses later

	constructor (address[] memory _whitelistAddresses) public {
		whitelist = _whitelistAddresses;
	}

	//@dev Prove that one of our whitelist address owners signed a message that included our
	// private key (string & int)
	function isValidData(uint256 _number, string memory _word, bytes memory sig) public view 
		returns (bool)
	{
		bytes32 message = keccak256(abi.encodePacked(_number, _word));
		uint8 i;
		for (i = 0; i < PRESALE_MAX; i++) {
			if (recoverSigner(message, sig) == whitelist[i]) {
				return true;
			}
		}
		return false;
	}

	//@dev Recover the address that signed this message
	function recoverSigner(bytes32 message, bytes memory sig) public pure returns (address)
	{
		uint8 v;
		bytes32 r;
		bytes32 s;

		(v, r, s) = splitSignature(sig);

		return ecrecover(message, v, r, s);
	}

	//@dev Obtain v, r, and s for a given signature
	function splitSignature(bytes memory sig) public pure returns (uint8, bytes32, bytes32)
	{
		require(sig.length == 65);

		bytes32 r;
		bytes32 s;
		uint8 v;

		assembly {
			//first 32 bytes, after the length prefix
			r := mload(add(sig,32))
			//second 32 bytes
			s := mload(add(sig,64))
			//final byte (first byte of the next 32 bytes)
			v := byte(0, mload(add(sig,96)))
		}

		return (v,r,s);
	}
}
