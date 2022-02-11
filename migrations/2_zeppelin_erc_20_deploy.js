const QBXZ = artifacts.require("QBXZ");

module.exports = function (deployer) {
    deployer.deploy(QBXZ, 1000000000000000000000n);
};