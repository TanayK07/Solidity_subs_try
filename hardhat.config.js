require("@nomicfoundation/hardhat-toolbox");

// Go to https://www.alchemyapi.io, sign up, create
// a new App in its dashboard, and replace "KEY" with its key
const ALCHEMY_API_KEY = "qLhkSYgDtwpGoYORMRBepC_xJIa2E9Fv";

// Replace this private key with your Goerli account private key
// To export your private key from Metamask, open Metamask and
// go to Account Details > Export Private Key
// Beware: NEVER put real Ether into testing accounts
const GOERLI_PRIVATE_KEY = "4c04caaaa2c08cfdf4492ea0eb77a53a3269d02ba8fbd350b37fc4f52eb91efc";

module.exports = {
  solidity: "0.8.9",
 // etherscan: {
   // apiKey: "1JUJA6HWZFATS1MIWTMUQVYGY7S4N3YMQ4",
  //},
  networks: {
    goerli: {
      url: `https://eth-goerli.alchemyapi.io/v2/${ALCHEMY_API_KEY}`,
      accounts: [GOERLI_PRIVATE_KEY]
    }
  }

};
