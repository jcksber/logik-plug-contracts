
require('dotenv').config();
const API_URL = process.env.API_URL;
const PUBLIC_KEY = process.env.PUBLIC_KEY;
const PRIVATE_KEY = process.env.PRIVATE_KEY;

const { createAlchemyWeb3 } = require("@alch/alchemy-web3");
const web3 = createAlchemyWeb3(API_URL);

// First we need to "construct" the contract
const blmContract = require("../../artifacts/contracts/BLMTest.sol/BLMTest.json");
const blmContractAddress = "0xAF07259aEC182eB7d4bBabf1F5Ef65D1E8C90E4f";
const blmNFT = new web3.eth.Contract(blmContract.abi, blmContractAddress);

// Next, we'll mint it to ourselves
async function mintCollectible(tokenURI) {
	// get latest nonce (for security purposes)
	const nonce = await web3.eth.getTransactionCount(PUBLIC_KEY, 'latest');
	// the transaction
	const tx = {
		'from': PUBLIC_KEY,
		'to': blmContractAddress,
		'nonce': nonce,
		'gas': 2000000,
		'data': blmNFT.methods.mintBLMTest(PUBLIC_KEY, tokenURI).encodeABI()
	}

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

mintCollectible("https://gateway.pinata.cloud/ipfs/QmQr5GPfbboVMkntaBYYSMoSzR29bZMGPNefon4GiCEZzm");



