require("@nomiclabs/hardhat-waffle");
require("dotenv").config();
const { RINKEBY_URL, PRIVATE_KEY } = process.env;
module.exports = {
  solidity: "0.8.4",
  networks: {
    rinkeby: {
      url: RINKEBY_URL,
      accounts: [`0x${PRIVATE_KEY}`]
    }
  }
};