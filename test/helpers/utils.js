const { ethers } = require("hardhat");
// const { should, expect, assert } = require("chai");



async function shouldThrow(promise) {
	try {
	    var result = await promise;
	    assert(true);
	}
	catch (err) {
	    return;
	}
	assert(false, "The contract did not throw.");

}

async function shouldNotThrow(promise) {
	try {
		var result = await promise;
		return;
	}
	catch (err) {
		assert(false, err);
	}
}

module.exports = {
  shouldThrow,
  shouldNotThrow
};
