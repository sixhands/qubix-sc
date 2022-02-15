const QBXC20 = artifacts.require("QBXC20");

module.exports = function (deployer) {
    deployer.deploy(QBXC20, 1000000000000000000000n);
};