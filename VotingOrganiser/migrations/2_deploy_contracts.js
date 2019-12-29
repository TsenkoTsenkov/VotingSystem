const Organise = artifacts.require("Organise");
const YesNoVoting = artifacts.require("YesNoVoting");

module.exports = function(deployer) {
  deployer.deploy(Organise);
  deployer.deploy(YesNoVoting);
};
