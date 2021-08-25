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
const { ethers } = require("hardhat");
const { expect } = require("chai");
const utils = require("./helpers/utils");
const time = require("./helpers/time");
const { createAlchemyWeb3 } = require("@alch/alchemy-web3");
const web3 = createAlchemyWeb3(API_URL);


// `describe` is a Mocha function that allows you to organize your tests. It's
// not actually needed, but having your tests organized makes debugging them
// easier. All Mocha functions are available in the global scope.

// `describe` receives the name of a section of your test suite, and a callback.
// The callback must define the tests of that section. This callback can't be
// an async function.
describe("Plug contract", function () {
	// Mocha has four functions that let you hook into the the test runner's
  	// lifecyle. These are: `before`, `beforeEach`, `after`, `afterEach`.

  	// They're very useful to setup the environment for tests, and to clean it
  	// up after they run.

  	// A common pattern is to declare some variables, and assign them in the
  	// `before` and `beforeEach` callbacks.

  	let Plug;
  	let hardhatPlug;
  	let alice;
  	let bob;
  	let trent;


  	// `beforeEach` will run before each test, re-deploying the contract every
    // time. It receives a callback, which can be async.
    beforeEach(async function () {
    	Plug = await ethers.getContractFactory("Plug");
    	[owner, alice, bob, trent, ...addrs] = await ethers.getSigners();

    	hardhatPlug = await PLug.deploy();
    });

    // `afterEach` will run after each test, destroying the deployed contract
    // every time.
    afterEach(async function () {
    	await hardhatPlug.kill();
    });

    // You can nest describe calls to create subsections.
    describe("Deployment", function () {
    	// `it` is another Mocha function. This is the one you use to define your
    	// tests. It receives the test name, and a callback function.

    	// If the callback function is async, Mocha will `await` it.
		it("Deployment should add my dev address to `_squad`", async function () {
			// Expect receives a value, and wraps it in an Assertion object. These
      		// objects have a lot of utility methods to assert values.
			const jackAddress = "0xEAb4Aea5cD7376C04923236c504e7e91362566D1";
			expect(await hardhatPlug.isInSquad(jackAddress)).to.equal(true);
		});

		it("Deployment should add logik's dev address to `_squad`", async function () {
			const logikAddress = "0x6b8C6E15818C74895c31A1C91390b3d42B336799";
			expect(await hardhatPlug.isInSquad(logikAddress)).to.equal(true);
		});
	});

	describe("Squad functionality", function () {
		it("Squad members should be addable", async function () {
			expect(isInSquad(alice)).to.equal(false);

			// Add alice to the squad
			await hardhatPlug.addToSquad(alice);

			expect(isInSquad(alice)).to.equal(true);
		});

		it("Squad members should be removable", async function () {
			expect(isInSquad(alice)).to.equal(false);

			// Add alice to the squad then remove her
			await hardhatPlug.addToSquad(alice);
			await hardhatPlug.removeFromSquad(alice);

			expect(isInSquad(alice)).to.equal(false);
		});
	});

	describe("Minting & burning", function () {
		it("Minting should increment the token id by 1 each time", async function () {
			let id = await hardhatPlug.mint721(owner);
			expect(id).to.equal(1);
			id = await hardhatPlug.mint721(alice);
			expect(id).to.equal(2);
		});

		it("Minting should set the birthday of `tokenId` to the current time", async function () {
			const aliceId = await hardhatPlug.mint721(alice);
			const aliceBday = await hardhatPlug.getBirthday(aliceId);
			let daysPassed = await hardhatPlug.countDaysPassed(aliceId);
			expect(daysPassed).to.equal(0);

			// Go 1 day into the future
			await time.increase(time.duration.days(1));

			daysPassed = await hardhatPlug.countDaysPassed(aliceId);
			expect(daysPassed).to.equal(1);
		});

		it("Burning should remove a token permnently", async function () {
			const id = await hardhatPlug.mint721(owner);
			const initialOwner = await hardhatPlug.ownerOf(id);
			expect(initialOwner).to.equal(owner);

			// Burn the token
			await hardhatPlug.burn721(id);

			utils.shouldThrow(await hardhatPlug.getBirthday(id));
		});
	});

	describe("Time-triggered asset cycling", function () {
		it("Plug should update it's hash every 60 days", async function () {
			// First we need to mint a token
		});
	});

	describe("Transfers", function () {
		//take this from zombies
	});

	describe("Miscellaneous", function () {

	});
});







