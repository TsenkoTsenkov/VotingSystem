const Organise = artifacts.require("./Organise.sol");

module.exports = function(deployer) {
  deployer.deploy(Organise);
};
