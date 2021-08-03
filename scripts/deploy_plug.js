// NOTE: in the future, let's make these non-main methods and consolidate into one script?
const { ethers } = require("hardhat");

// DEPLOY TIER 2 GIF'S

async function main() {
	const Gif = await ethers.getContractFactory("LOGIKGif");

	// Start deployment
	const gif = await Gif.deploy();
	console.log("LOGIKGif contract deployed to address:", gif.address);
}

main()
	.then(() => process.exit(0))
	.catch(error => {
		console.log(error);
		process.exit(1);
	});
