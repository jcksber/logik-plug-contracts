/*
 * Deployment script for Plug.sol
 *
 * Created: August 9, 2021
 * Author: Jack Kasbeer
 */

const { ethers, upgrades } = require("hardhat");

async function main() {
	const gas = { 'gasPrice': 50000 }
	const Plug = await ethers.getContractFactory("Plug");
	const instance = await Plug.deploy();

	console.log(instance.deployTransaction);


	console.log("Plug contract deployed to address:", instance.address);
}

main()
	.then(() => process.exit(0))
	.catch(error => {
		console.log(error);
		process.exit(1);
	});
