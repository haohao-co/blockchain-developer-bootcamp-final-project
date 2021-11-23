const dotenv = require("dotenv");
dotenv.config();

const path = require("path");
const HDWalletProvider = require("@truffle/hdwallet-provider");
const mnemonic = process.env.RINKEBY_MNEMONIC;

module.exports = {
  // Note: testnet config for deployment is not checked in for security concern.
  contracts_build_directory: path.join(__dirname, "client/src/contracts"),
  networks: {
    develop: {
      port: 8545
    },
    rinkeby: {
      provider: function () {
        return new HDWalletProvider(mnemonic, `https://rinkeby.infura.io/v3/${process.env.RINKEBY_INFURA_PROJECT_ID}`)
      },
      network_id: 4,
      gas: 4000000  // make sure this gas allocation isn't over 4M, which is the max
    }
  },
  compilers: {
    solc: {
      version: "0.8.4"
    }
  }
};
