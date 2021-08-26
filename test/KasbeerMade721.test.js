require('dotenv').config();
const API_URL = process.env.STAGING_ALCHEMY_API_URL;

const { ethers } = require("hardhat");
const { expect, use } = require("chai");
const { Contract } = require("ethers");
const { shouldThrow, shouldNotThrow } = require("./helpers/utils");
const time = require("./helpers/time");
const { deployContract, MockProvider, solidity } = require('ethereum-waffle');
const KM721 = require('../artifacts/contracts/KasbeerMade721.sol/KasbeerMade721.json');

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
		//KM721 = await ethers.getContractFactory(":KasbeerMade721")
		// [owner, bob, alice] = await ethers.getSigners();
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
