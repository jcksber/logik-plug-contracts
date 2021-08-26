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

const { should, expect, assert } = require("chai");
const { shouldThrow, shouldNotThrow } = require("./helpers/utils");
const time = require("./helpers/time");

const { createAlchemyWeb3 } = require("@alch/alchemy-web3");
const web3 = createAlchemyWeb3(API_URL);



// `describe` is a Mocha function that allows you to organize your tests. It's
// not actually needed, but having your tests organized makes debugging them
// easier. All Mocha functions are available in the global scope.

// `describe` receives the name of a section of your test suite, and a callback.
// The callback must define the tests of that section. This callback can't be
// an async function.
describe("KasbeerMade721 contract", function () {
	// Mocha has four functions that let you hook into the the test runner's
  	// lifecyle. These are: `before`, `beforeEach`, `after`, `afterEach`.

  	// They're very useful to setup the environment for tests, and to clean it
  	// up after they run.

  	// A common pattern is to declare some variables, and assign them in the
  	// `before` and `beforeEach` callbacks.
  	let KM721;
  	let hardhatKM721;
  	let owner;
  	let alice;
  	let bob;


  	// `beforeEach` will run before each test, re-deploying the contract every
    // time. It receives a callback, which can be async.
    beforeEach(async function () {
    	KM721 = await ethers.getContractFactory("KasbeerMade721");
    	[owner, bob, alice, ...addrs] = await ethers.getSigners();

    	hardhatKM721 = await KM721.deploy("The Plug", "");
    });

    // `afterEach` will run after each test, destroying the deployed contract
    // every time.
    afterEach(async function () {
    	KM721 = null;
    	hardhatKM721 = null;
    	owner = null;
    	alice = null;
    	bob = null;
    });

    // You can nest describe calls to create subsections.
    describe("Deployment", function () {
    	// `it` is another Mocha function. This is the one you use to define your
    	// tests. It receives the test name, and a callback function.

    	// If the callback function is async, Mocha will `await` it.
		it("Deployment should add my dev address to `_squad`", async function () {
			// Expect receives a value, and wraps it in an Assertion object. These
      		// objects have a lot of utility methods to assert values.
			expect(await hardhatKM721.isInSquad(owner.address)).to.equal(true);
		});

	});

	describe("Squad functionality", function () {
		it("Squad members should be addable", async function () {
			// Add alice to the squad
			shouldNotThrow(await hardhatKM721.addToSquad(alice.address));
			expect (await hardhatKM721.isInSquad(owner.address.toString())).to.equal(true);
			expect(await hardhatKM721.isInSquad(alice.address.toString())).to.equal(true);
		});

		it("Squad members should be removable", async function () {
			// Add alice to the squad then remove her
			shouldNotThrow(await hardhatKM721.addToSquad(alice.address));
			shouldNotThrow(await hardhatKM721.removeFromSquad(alice.address));

			expect(await hardhatKM721.isInSquad(alice.address)).to.equal(false);
		});
	});

	// describe("Minting & burning", function () {
	// 	it("Minting should increment the token id by 1 each time", async function () {
	// 		const id1 = await hardhatPlug.mint721(owner.address);
	// 		expect(id1).to.equal(1);
	// 		const id2 = await hardhatPlug.mint721(owner.address);
	// 		expect(id2).to.equal(2);

	// 		// instead, let's change the test to mint MAX_NUM_PLUGS and check the id 
	// 		// each time
	// 	});

	// 	it("Minting should set the birthday of `tokenId` to the current time", async function () {
	// 		const id = await hardhatPlug.mint721(owner.address);
	// 		const bday = await hardhatPlug.getBirthday(id);
	// 		const daysPassed1 = await hardhatPlug.countDaysPassed(id);
	// 		expect(daysPassed1).to.equal(0);

	// 		// Go 1 day into the future
	// 		await time.increase(time.duration.days(1));

	// 		const daysPassed2 = await hardhatPlug.countDaysPassed(id);
	// 		expect(daysPassed2).to.equal(1);
	// 	});

	// 	it("Burning should remove a token permnently", async function () {
	// 		const id = await hardhatPlug.mint721(owner.address);
	// 		const initialOwner = await hardhatPlug.ownerOf(id);
	// 		expect(initialOwner).to.equal(owner.address);

	// 		// Burn the token
	// 		await hardhatPlug.burn721(id);

	// 		shouldThrow(await hardhatPlug.getBirthday(id));
	// 	});
	// });

	// describe("Time-triggered asset cycling", function () {
	// 	it("Plug should update it's hash every 60 days for the first year", async function () {
	// 		// First we need to mint a token
	// 		const id = await hardhatPlug.mint721(owner.address);
	// 		const baseURI = "https://ipfs.io/ipfs/";

	// 		// Next, increase time until 1 year has passed (pre-alchemist) 
	// 		// (in 60 day increments)
	// 		var i, j, uri, hash;
	// 		for (i = 0; i <= 360; i += 60) {
	// 			// Increase time (after first iteration)
	// 			await time.increase(time.duration.days(i));
	// 			// Find out what the token's current URI is & compare
	// 			j = i / 60;

	// 			uri = await hardhatPlug.tokenURI(id);
	// 			hash = await hardhatPlug.getHashByIndex(j);
	// 			URI = baseURI + hash;

	// 			expect(uri).to.equal(URI);
	// 		}
	// 	});

	// 	it("Plug should turn into an Alchemist after 4 years", async function () {
	// 		// First, mint a token
	// 		const id = await hardhatPlug.mint721(owner.address);
	// 		const baseURI = "https://ipfs.io/ipfs/";
	// 		const hash = await hardhatPlug.getHashByIndex(7);
	// 		const URI = baseURI + hash;

	// 		// Go 4 years into the future
	// 		await time.increase(time.duration.days(1440));

	// 		expect(await hardhatPlug.isAlchemist(id)).to.equal(true);
	// 		expect(await hardhatPlug.tokenURI(id)).to.equal(URI);
	// 	});
	// });

	// describe("Transfers", function () {
	// 	//take this from zombies
	// });

	// describe("Miscellaneous", function () {

	// });
});







