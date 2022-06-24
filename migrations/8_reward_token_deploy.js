const QBXM = artifacts.require("QBXM");
const Reward = artifacts.require("Reward");

module.exports = async function (deployer) {
    await deployer.deploy(
        QBXM
    );

    const qbxc = await QBXM.deployed()

    await deployer.deploy(
        Reward,
        "0x32289C3688CEbf515A065E7D25DC5cEFDb6E9c12",
        qbxc.address
    );
};
