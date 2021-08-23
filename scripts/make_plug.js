/*
 * Deployment & minting script for Plug.sol
 *
 * Created: August 21, 2021
 * Author: Jack Kasbeer
 */

// Globals for minting
require('dotenv').config();
const ALCHEMY_API_URL = process.env.STAGING_ALCHEMY_API_URL;
const PRIVATE_KEY = process.env.STAGING_PRIVATE_KEY;
const PUBLIC_KEY = process.env.STAGING_PUBLIC_KEY;
const plugContract = require("../artifacts/contracts/Plug.sol/Plug.json");

// Globals for deploying
const { ethers, upgrades } = require("hardhat");
const { createAlchemyWeb3 } = require("@alch/alchemy-web3");
const web3 = createAlchemyWeb3(ALCHEMY_API_URL);//needed for minting


// async function mintPlug(address) {
// 	const nonce = await web3.eth.getTransactionCount(PUBLIC_KEY, 'latest');
// 	const plugNFT = new web3.eth.Contract(plugContract.abi, address);
// 	// the transaction
// 	const tx = {
// 		'from': PUBLIC_KEY,
// 		'to': address,
// 		'nonce': nonce,
// 		'gas': 500000,
// 		'data': plugNFT.methods.mintPlug(PUBLIC_KEY).encodeABI()
// 	};

// 	const signPromise = web3.eth.accounts.signTransaction(tx, PRIVATE_KEY);
// 	signPromise.then((signedTx) => {

// 		web3.eth.sendSignedTransaction(signedTx.rawTransaction, function(err, hash) {
// 			if (!err) {
// 				console.log("The hash of your transaction is: ", hash, "\nCheck Alchemy's Mempool to view the status of your transaction!");
// 			} else {
// 				console.log("Something went wrong when submitting your transaction:", err);
// 			}
// 		});
// 	}).catch((err) => {
// 		console.log("Promise failed:", err);
// 	});
// }

async function main() {
	// Variables for deployment
	const Plug = await ethers.getContractFactory("Plug");
	const instance = await Plug.deploy();

	// Message to user that the contract deployed successfully
	//console.log("Plug contract deployed to address:", instance.address);
	
	// Mint the NFT
	//const minted = await mintPlug(instance.address);
	const nonce = await web3.eth.getTransactionCount(PUBLIC_KEY, 'latest');
	const plugNFT = new web3.eth.Contract(plugContract.abi, instance.address);
	// the transaction
	const tx = {
		'from': PUBLIC_KEY,
		'to': instance.address,
		'nonce': nonce,
		'gas': 500000,
		'data': plugNFT.methods.mintPlug(PUBLIC_KEY).encodeABI()
	};

	const signPromise = web3.eth.accounts.signTransaction(tx, PRIVATE_KEY);
	signPromise.then((signedTx) => {

		web3.eth.sendSignedTransaction(signedTx.rawTransaction, function(err, hash) {
			if (!err) {
				console.log("The hash of your transaction is: ", hash, "\nCheck Alchemy's Mempool to view the status of your transaction!");
			} else {
				console.log("Something went wrong when submitting your transaction:", err);
			}
		});
	}).catch((err) => {
		console.log("Promise failed:", err);
	});
}

main()
	.then(() => process.exit(0))
	.catch(error => {
		console.log(error);
		process.exit(1);
	});
