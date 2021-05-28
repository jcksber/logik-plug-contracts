require('dotenv');
const API_URL = process.env.API_URL;
const { createAlchemyWeb3 } = require("@alch/alchemy-web3");
const web3 = createAlchemyWeb3(API_URL);

const contract = require("../../artifacts/contracts/LOGIKStamp.sol/LOGIKStamp.json");
const contractAddress = "0x8322ff6ACa5EDB0c7575Fe853327b0Dd08f26e07";
const nftContract = new web3.eth.Contract(contract.abi, contractAddress);