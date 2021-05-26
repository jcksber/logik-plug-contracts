async function main() {
	const LOGIKStamp = await ethers.getContractFactory("LOGIKStamp");

	// Start deployment, returning a promise that resolves to a contract object
	const stamps = await LOGIKStamp.deploy();
	console.log("Contract deployed to address:", stamps.address);
}

main()
	.then(() => process.exit(0))
	.catch(error => {
		console.error(error);
		process.exit(1);
	});
