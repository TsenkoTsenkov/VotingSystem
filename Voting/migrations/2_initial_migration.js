const YesNoVoting = artifacts.require("./YesNoVoting.sol");

module.exports = function(deployer) {
  deployer.deploy(YesNoVoting);
};
