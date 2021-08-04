/*
 * Deployment script for Plug.sol
 *
 * Created: June 3, 2021
 * Author: Jack Kasbeer
 */
const { ethers } = require("hardhat");

async function main() {
	const Plug = await ethers.getContractFactory("Plug");

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
