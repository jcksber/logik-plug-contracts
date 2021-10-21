/**
* @type import('hardhat/config').HardhatUserConfig
*/
require('dotenv').config();
require("@nomiclabs/hardhat-ethers");
require("@nomiclabs/hardhat-waffle");
require("@nomiclabs/hardhat-etherscan");
require('hardhat-abi-exporter');

const { STAGING_ALCHEMY_API_URL, 
        STAGING_PRIVATE_KEY,
        JACK_PRIVATE_KEY,
        JACK_PRIVATE_KEY,
        PRODUCTION_ALCHEMY_API_URL,
        PRODUCTION_PRIVATE_KEY } = process.env;

module.exports = {
   solidity: {
      compilers: [
         {
            version: '0.8.7',
            settings: {
               optimizer: {
                  enabled: true,
                  runs: 200,
               },
            },
         },
         {
            version: '0.8.1',
            settings: {},
         },
         {
            version: '0.8.0',
            settings: {},
         },
         {
            version: '0.7.3',
            settings: {},
         },
         {
            version: '0.6.2',
            settings: {},
         }
      ]
   },
   defaultNetwork: "rinkeby",
   networks: {
      hardhat: {},
      rinkeby: {
         url: STAGING_ALCHEMY_API_URL,
         accounts: [`0x${STAGING_PRIVATE_KEY}`, `0x${JACK_PRIVATE_KEY}`]
      },
      // mainnet: {
      // 	url: PRODUCTION_ALCHEMY_API_URL,
      // 	accounts: [`0x${PRODUCTION_PRIVATE_KEY}`]
      // }
   },
   abiExporter: {
      path: './data/abi',
      clear: true,
      flat: true
   },
   etherscan: {
      apiKey: "N2A3Z2D8UQRE2QZUKCGDY1QK6SAUXVG7JV"
   }
}
