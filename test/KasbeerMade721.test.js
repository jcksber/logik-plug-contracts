require('dotenv').config();
const API_URL = process.env.STAGING_ALCHEMY_API_URL;

const { ethers } = require("hardhat");
const { expect, use } = require("chai");
const { Contract } = require("ethers");
const { shouldThrow, shouldNotThrow } = require("./helpers/utils");
const time = require("./helpers/time");
const { deployContract, MockProvider, solidity } = require('ethereum-waffle');
const KM721 = require('../artifacts/contracts/KasbeerMade721.sol/KasbeerMade721.json');

// const { createAlchemyWeb3 } = require("@alch/alchemy-web3");
// const web3 = createAlchemyWeb3(API_URL);

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

		it("Burning should remove a token permanently", async function () {
			// Non-squad member can't burn a token
			await token.addToSquad(owner.address);
			expect(await token.isInSquad(owner.address)).to.equal(true);

			// Mint a token to alice before burning it
			await token.mint721(alice.address);
			let id = await token.getCurrentTokenId();
			id = parseInt(id._hex);

			// Burn the token
			await expect(token.burn721(id))
				.to.emit(token, "ERC721Burned")
				.withArgs(id);
		});
	});

	describe("Token URI", function () {
		it("KasbeerMade721 should only return a token uri if the token exists & should simply be baseURI", async function () {
			// Mint a token just so `tokenURI` doesn't fail
			await token.mint721(alice.address);
			const id = await token.getCurrentTokenId();
			const baseURI = "https://ipfs.io/ipfs/";

			const uri = await token.tokenURI(id);
			expect(uri).to.equal(baseURI);
		});

	});
});




