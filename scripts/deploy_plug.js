/*
 * Deployment script for Plug.sol
 *
 * Created: August 9, 2021
 * Author: Jack Kasbeer
 */

const { ethers } = require("hardhat");

async function main() {
	const Plug = await ethers.getContractFactory("PlugTest2");

	// Start deployment
	const plug = await Plug.deploy();
	console.log("Plug contract deployed to address:", plug.address);
}

main()
	.then(() => process.exit(0))
	.catch(error => {
		console.log(error);
		process.exit(1);
	});
