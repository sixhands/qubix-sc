const QBXC777 = artifacts.require("QBXC777");

module.exports = async function (deployer) {
    deployer.deploy(QBXC777, 3000000000000000000000n);
}
