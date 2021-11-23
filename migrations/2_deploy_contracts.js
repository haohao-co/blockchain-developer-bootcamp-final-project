var NftTradingPlatform = artifacts.require("./NftTradingPlatform.sol");

module.exports = function(deployer) {
  deployer.deploy(NftTradingPlatform);
};
