const QBXM = artifacts.require("QBXM");
const Reward = artifacts.require("Reward");

module.exports = async function (deployer) {
    await deployer.deploy(
        QBXM
    );

    const qbxc = await QBXM.deployed()

    await deployer.deploy(
        Reward,
        "0x3060f86c3c8c6C9eA9c03dD85204520E97298022",
        qbxc.address
    );
};
