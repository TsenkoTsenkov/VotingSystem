const Organise = artifacts.require("Organisation");
/*const YesNoVoting = artifacts.require("YesNoVoting");
const AbstractVoting = artifacts.require("AbstractVoting");
const AbstractMajoritarian = artifacts.require("AbstractMajoritarian");*/

module.exports = function(deployer) {
  deployer.deploy(Organise, ["0x769023866935694E950fe26D0DAecDB1b73f2027", "0x37993b4aD6E465f8ec1FDD50f1Dab345364f758c"]);
 /* deployer.deploy(AbstractVoting);
  deployer.deploy(YesNoVoting);
  deployer.deploy(AbstractMajoritarian);*/
};
