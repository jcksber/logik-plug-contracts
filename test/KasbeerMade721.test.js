require('dotenv').config();
const API_URL = process.env.STAGING_ALCHEMY_API_URL;

const { ethers } = require("hardhat");
const { expect, use } = require("chai");
const { Contract } = require("ethers");
const { shouldThrow, shouldNotThrow } = require("./helpers/utils");
const time = require("./helpers/time");
const { deployContract, MockProvider, solidity } = require('ethereum-waffle');
const KM721 = require('../artifacts/contracts/KasbeerMade721.sol/KasbeerMade721.json');

const MAX_MINTS = 22;
const me = "0xEAb4Aea5cD7376C04923236c504e7e91362566D1";
// NOTE: 'me' is technically not the owner of the contract since 
// one of the MockProvider wallets (owner) is the deployer

use(solidity);

describe('KasbeerMade721 contract', () => {
	let token = Contract;
	let owner;
	let alice;
	let bob;

	beforeEach(async function () {
		//[owner, bob, alice] = await ethers.getSigners();
		// BROKEN LINE!!!! ^^^^
		[owner, alice, bob] = new MockProvider().getWallets();
		token = await deployContract(owner, KM721, ["The Plug", ""]);
	});

	// You can nest describe calls to create subsections.
    describe("Deployment", function () {
    	// `it` is another Mocha function. This is the one you use to define your
    	// tests. It receives the test name, and a callback function.
    	// console.log(owner.addres);
    	// If the callback function is async, Mocha will `await` it.
		it("Deployment should add my dev address to `_squad`", async function () {
			// Expect receives a value, and wraps it in an Assertion object. These
      		// objects have a lot of utility methods to assert values.
			expect(await token.isInSquad(me)).to.equal(true);
		});

	});

	describe("Squad functionality", function () {
		it("Squad members should be addable", async function () {
			// Add alice to the squad
			shouldNotThrow(await token.addToSquad(alice.address));
			expect(await token.isInSquad(alice.address)).to.equal(true);
		});

		it("Squad members should be removable", async function () {
			// Add alice to the squad then remove her
			shouldNotThrow(await token.addToSquad(alice.address));
			shouldNotThrow(await token.removeFromSquad(alice.address));

			expect(await token.isInSquad(alice.address)).to.equal(false);
		});
	});

	describe("Minting & burning", function () {
		it("Minting should increment the token id by 1 each time", async function () {
			var i;
			for (i = 1; i <= MAX_MINTS; i++) {
				await token.mint721(bob.address);
				expect(await token.getCurrentTokenId()).to.equal(i);
			}
		});

		/* This test is failing with this error:
			Error: cannot estimate gas; transaction may fail or may require manual gas limit (error={"name":"RuntimeError","results":{"0x45cf857cf348509ce80bd5d2634b1a5625fb0f0380f3ba2447bbfd644d183ed6":{"error":"revert","program_counter":4097,"return":"0x08c379a0000000000000000000000000000000000000000000000000000000000000002000000000000000000000000000000000000000000000000000000000000000294b6173626565724d6164653732313a2043616c6c6572206e6f742070617274206f662073717561642e0000000000000000000000000000000000000000000000","reason":"KasbeerMade721: Caller not part of squad."}},"hashes":["0x45cf857cf348509ce80bd5d2634b1a5625fb0f0380f3ba2447bbfd644d183ed6"],"message":"VM Exception while processing transaction: revert KasbeerMade721: Caller not part of squad."}, tx={"data":"0xc6eee8a20000000000000000000000000000000000000000000000000000000000000001","to":{},"from":"0x17ec8597ff92C3F44523bDc65BF0f1bE632917ff","gasPrice":{"type":"BigNumber","hex":"0x77359400"},"type":0,"nonce":{},"gasLimit":{},"chainId":{}}, code=UNPREDICTABLE_GAS_LIMIT, version=abstract-signer/5.4.1)
		*/
		xit("Burning should remove a token permnently", async function () {
			await token.mint721(alice.address);
			const id = await token.getCurrentTokenId();

			// Burn the token
			await token.burn721(id);

			// expect(await token.tokenExists(id)).to.equal(false);
		});
	});

	// it('Assigns initial balance', async () => {
	// 	expect(await token.balanceOf(wallet.address)).to.equal(1000);
	// });

	// it('Transfer adds amount to destination account', async () => {
	// 	await token.transfer(walletTo.address, 7);
	// 	expect(await token.balanceOf(walletTo.address)).to.equal(7);
	// });

	// it('Transfer emits event', async () => {
	// 	await expect(token.transfer(walletTo.address, 7))
	// 		.to.emit(token, 'Transfer')
	// 		.withArgs(wallet.address, walletTo.address, 7);
	// });

	// it('Can not transfer above the amount', async () => {
	// 	await expect(token.transfer(walletTo.address, 1007)).to.be.reverted;
	// });

	// it('Can not transfer from empty account', async () => {
	// 	const tokenFromOtherWallet = token.connect(walletTo);
	// 	await expect(tokenFromOtherWallet.transfer(wallet.address, 1))
	// 		.to.be.reverted;
	// });

	// it('Calls totalSupply on BasicToken contract', async () => {
	// 	await token.totalSupply();
	// 	expect('totalSupply').to.be.calledOnContract(token);
	// });

	// it('Calls balanceOf with sender address on BasicToken contract', async () => {
	// 	await token.balanceOf(wallet.address);
	// 	expect('balanceOf').to.be.calledOnContractWith(token, [wallet.address]);
	// });
});
