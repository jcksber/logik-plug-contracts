
require('dotenv').config();
const API_URL = process.env.API_URL;
const PUBLIC_KEY = process.env.PUBLIC_KEY;
const PRIVATE_KEY = process.env.PRIVATE_KEY;

const { createAlchemyWeb3 } = require("@alch/alchemy-web3");
const web3 = createAlchemyWeb3(API_URL);

// First we need to "construct" the contract
const collectibleContract = require("../artifacts/contracts/LOGIK721Test.sol/LOGIK721Test.json");
const collectibleContractAddress = "0x731d2e8937B32C9C4a8F11ae3C0DcbeE9B9454f3";
const collectibleNFT = new web3.eth.Contract(collectibleContract.abi, collectibleContractAddress);

// Next, we'll mint it to ourselves
async function mintCollectible(tokenURI) {
	// get latest nonce (for security purposes)
	const nonce = await web3.eth.getTransactionCount(PUBLIC_KEY, 'latest');
	// the transaction
	const tx = {
		'from': PUBLIC_KEY,
		'to': collectibleContractAddress,
		'nonce': nonce,
		'gas': 2000000,
		'data': collectibleNFT.methods.mintCollectible721(PUBLIC_KEY, tokenURI).encodeABI()
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

mintCollectible("https://logik-genesis-api.herokuapp.com/api/other/collectible.json");



