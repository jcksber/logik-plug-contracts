/*
 * Plug.js
 *
 * Created: August 24, 2021
 * Author: Jack Kasbeer
 *
 * Test suite for Plug.sol 
 *
 */

require('dotenv').config();

const API_URL = process.env.STAGING_ALCHEMY_API_URL;
const { createAlchemyWeb3 } = require("@alch/alchemy-web3");
const web3 = createAlchemyWeb3(API_URL);

const { ethers } = require("hardhat");
const { expect, use } = require("chai");
const { Contract } = require("ethers");

const { shouldThrow, shouldNotThrow } = require("./helpers/utils");
const time = require("./helpers/time");
// const advanceBlockAtTime = (time) => {
//   return new Promise((resolve, reject) => {
//     web3.currentProvider.send(
//       {
//         jsonrpc: "2.0",
//         method: "evm_mine",
//         params: [time],
//         id: new Date().getTime(),
//       },
//       (err, _) => {
//         if (err) {
//           return reject(err);
//         }
//         const newBlockHash = web3.eth.getBlock("latest").hash;

//         return resolve(newBlockHash);
//       },
//     );
//   });
// };
const { deployContract, MockProvider, solidity } = require('ethereum-waffle');
const Plug = require('../artifacts/contracts/Plug.sol/Plug.json');

// const { createAlchemyWeb3 } = require("@alch/alchemy-web3");
// const web3 = createAlchemyWeb3(API_URL);
const logik = "0x6b8C6E15818C74895c31A1C91390b3d42B336799";
const baseURI = "https://ipfs.io/ipfs/";
const FINAL_IDX = 7;

use(solidity);

describe("Plug contract", function () {
  	let plug = Contract;
  	let owner;
  	let alice;
  	let bob;

  	// Re-deploy before each test so that contract is in a fresh state
    beforeEach(async function () {
    	[owner, bob, alice] = new MockProvider().getWallets();
    	plug = await deployContract(owner, Plug, []);
    });

    describe("Deployment", function () {
		it("Deployment should add LOGIK's dev address to `_squad`", async function () {
			expect(await plug.isInSquad(logik)).to.equal(true);
		});
	});

	describe("Token URI: Time-triggered asset cycling", function () {
		xit("Plug should update it's hash every 60 days for the first year", async function () {
			// First we need to mint a token
			await plug.mint721(alice.address);
			const id = await plug.getCurrentTokenId();

			
			let i, j, uri, hash;
			// Next, increase time until 1 year has passed (pre-alchemist) 
			// (in 60 day increments)
			// Check to see that the asset changes each iteration
			for (i = 0; i <= 360; i += 60) {
				// Increase time (after first iteration)
				await time.increase(time.duration.days(i));
				// Find out what the token's current URI is & compare
				j = i / 60;
				uri = await plug.tokenURI(id);
				hash = await plug.getHashByIndex(j);
				URI = baseURI + hash;
				// The URI should be equal to assetHashes[j]
				expect(uri).to.equal(URI);
			}
		});
		xit("Plug should turn into an Alchemist after 4 years", async function () {
			// First, mint a token
			await plug.mint721(alice.address);
			const id = await plug.getCurrentTokenId();
			const hash = await plug.getHashByIndex(FINAL_IDX);
			const URI = baseURI + hash;

			// Go 4 years into the future
			await time.increase(time.duration.days(1440));

			// Now, the plug should be an alchemist & have the correct hash
			expect(await plug.isAlchemist(id)).to.equal(true);
			expect(await plug.tokenURI(id)).to.equal(URI);
		});
	});

	describe("Minting", function () {
		it("Minting should set the birthday of `tokenId` to the current time", async function () {
			await plug.mint721(alice.address);
			const id = await plug.getCurrentTokenId();
			const bday = await plug.getBirthday(id);

			// Present day (sanity check)
			const daysPassed1 = await plug.countDaysPassed(id);
			expect(daysPassed1).to.equal(0);

			// Go 1 day into the future
			// await time.increase(time.duration.days(1));

			// const daysPassed2 = await plug.countDaysPassed(id);
			// expect(daysPassed2).to.equal("1");
		});
	});

	// describe("Transfers", function () {
	// 	//take this from zombies
	// });

	// describe("Miscellaneous", function () {

	// });
});







