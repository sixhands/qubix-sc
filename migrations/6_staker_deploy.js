const Staker = artifacts.require("StakingPrototype");

module.exports = function (deployer) {
    deployer.deploy(Staker);
};