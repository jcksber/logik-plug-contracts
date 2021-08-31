/*
 * Deployment script for PlugERC721.sol
 *
 * Created: August 30, 2021
 * Author: Jack Kasbeer
 */

const { ethers, upgrades } = require("hardhat");

async function main() {
	const gas = { 'gasPrice': 50000 }
	const ThePlug = await ethers.getContractFactory("ThePlug");
	const instance = await ThePlug.deploy();

	console.log(instance.deployTransaction);

	console.log("Plug contract deployed to address:", instance.address);
}

main()
	.then(() => process.exit(0))
	.catch(error => {
		console.log(error);
		process.exit(1);
	});