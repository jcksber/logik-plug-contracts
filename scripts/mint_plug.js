/*
 * Mint script for Plug.sol
 *
 * Created: August 4, 2021
 * Author: Jack Kasbeer
 */

require('dotenv').config();
const ALCHEMY_API_URL = process.env.STAGING_ALCHEMY_API_URL;
const PRIVATE_KEY = process.env.STAGING_PRIVATE_KEY;
const PUBLIC_KEY = process.env.STAGING_PUBLIC_KEY;

const { createAlchemyWeb3 } = require("@alch/alchemy-web3");
const web3 = createAlchemyWeb3(ALCHEMY_API_URL);

const plugContract=require("../artifacts/contracts/Plug.sol/Plug.json");
const plugAddress = "0xeA7657BaE5C75e537a6BB30d39AFEc3F4d591F8a";//rinkeby
const plugNFT = new web3.eth.Contract(plugContract.abi, plugAddress);

async function mintPlug() {
	const nonce = await web3.eth.getTransactionCount(PUBLIC_KEY, 'latest');

	// the transaction
	const tx = {
		'from': PUBLIC_KEY,
		'to': plugAddress,
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

mintPlug();
