/*
 * Deployment script for Plug.sol
 *
 * Created: August 9, 2021
 * Author: Jack Kasbeer
 */

const { ethers, upgrades } = require("hardhat");

async function main() {
	const Plug = await ethers.getContractFactory("PlugTest4");
	const instance = await upgrades.deployProxy(Plug);
	await instance.deployed();

	console.log("Plug contract deployed to address:", instance.address);

	// Upgrading 
    // const BoxV2 = await ethers.getContractFactory("BoxV2");
    // const upgraded = await upgrades.upgradeProxy(instance.address, BoxV2);
}

main()
	.then(() => process.exit(0))
	.catch(error => {
		console.log(error);
		process.exit(1);
	});
