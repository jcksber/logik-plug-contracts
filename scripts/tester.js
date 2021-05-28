// determine owner
require('dotenv').config();
const API_URL = process.env.API_URL;

const { createAlchemyWeb3 } = require("@alch/alchemy-web3");
const web3 = createAlchemyWeb3(API_URL);

async function main() {
	const collectibleContract = require("../artifacts/contracts/LOGIKCollectible.sol/LOGIKCollectible.json");
	const collectibleContractAddress = "0x2AE7271F29d231133C1fC987b928378695Bdcdb9";
	const collectibleNFT = new web3.eth.Contract(collectibleContract.abi, collectibleContractAddress);
	//collectibleNFT.methods.transferOwnership("0xEAb4Aea5cD7376C04923236c504e7e91362566D1");
	console.log(collectibleNFT.methods.ownerOf(0));
}

main()
	.then(() => process.exit(0))
	.catch(error => {
		console.log(error);
		process.exit(1);
	});
