// NOTE: in the future, let's make these non-main methods and consolidate into one script?
const { ethers } = require("hardhat");

// DEPLOY TIER 3 COLLECTIBLES

async function main() {
	const Collectible = await ethers.getContractFactory("LOGIK721Test");

	// Start deployment
	const collectible = await Collectible.deploy();
	console.log("Contract deployed to address:", collectible.address);
}

main()
	.then(() => process.exit(0))
	.catch(error => {
		console.log(error);
		process.exit(1);
	});
