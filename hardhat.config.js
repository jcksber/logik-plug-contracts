/**
* @type import('hardhat/config').HardhatUserConfig
*/
require('dotenv').config();
require("@nomiclabs/hardhat-ethers");
const { STAGING_ALCHEMY_API_URL, STAGING_PRIVATE_KEY } = process.env;
module.exports = {
   solidity: "0.7.3",
   defaultNetwork: "rinkeby",
   networks: {
      hardhat: {},
      rinkeby: {
         url: STAGING_ALCHEMY_API_URL,
         accounts: [`0x${STAGING_PRIVATE_KEY}`]
      }
   },
}