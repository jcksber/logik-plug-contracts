// NOTE: in the future, let's make these non-main methods and consolidate into one script?
const { ethers } = require("hardhat");

// DEPLOY BLM NFT's

async function main() {
	const BLMTest = await ethers.getContractFactory("BLMTest");

	// Start deployment
	const blm = await BLMTest.deploy();
	console.log("Contract deployed to address:", blm.address);
}

main()
	.then(() => process.exit(0))
	.catch(error => {
		console.log(error);
		process.exit(1);
	});
