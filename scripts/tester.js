// determine owner
require('dotenv').config();
const API_URL = process.env.API_URL;

const { createAlchemyWeb3 } = require("@alch/alchemy-web3");
const web3 = createAlchemyWeb3(API_URL);

async function main() {
	const blmContract = require("../artifacts/contracts/BLMTest.sol/BLMTest.json");
	const blmContractAddress = "0x43dCF5A67192DE38A97cba05aB053FC186DF2d5d";
	const blmNFT = new web3.eth.Contract(blmContract.abi, blmContractAddress);
	const hour = blmNFT.methods.hourNow().call();
	return hour;
}

async function test() {
	// const hour = blmNFT.methods.hourNow().call();
	// return hour;
}

main()
	.then((hour) => {
		console.log(hour);
		process.exit(0);
	})
	.catch(error => {
		console.log(error);
		process.exit(1);
	});

// test()
// 	.then((hour) => console.log('hour: ', hour));