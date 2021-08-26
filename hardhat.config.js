/**
* @type import('hardhat/config').HardhatUserConfig
*/
require('dotenv').config();
require("@nomiclabs/hardhat-ethers");
require("@nomiclabs/hardhat-waffle");
require("@openzeppelin/hardhat-upgrades");
const { STAGING_ALCHEMY_API_URL, 
        STAGING_PRIVATE_KEY,
        BOB_PRIVATE_KEY,
        ALICE_PRIVATE_KEY } = process.env;
module.exports = {
   solidity: {
      compilers: [
      {
            version: '0.8.1',
            settings: {}
         },
         {
            version: '0.8.0',
            settings: {}
         }
      ]
   },
   defaultNetwork: "rinkeby",
   networks: {
      hardhat: {},
      rinkeby: {
         url: STAGING_ALCHEMY_API_URL,
         accounts: [`0x${STAGING_PRIVATE_KEY}`, `0x${BOB_PRIVATE_KEY}`, `0x${ALICE_PRIVATE_KEY}`]
      },
      // mainnet: {
      // 	url: PRODUCTION_ALCHEMY_API_URL,
      // 	accounts: [`0x${PRODUCTION_PRIVATE_KEY}`]
      // }
   },
}