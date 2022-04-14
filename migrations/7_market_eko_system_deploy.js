const QBXM = artifacts.require("QBXM");
const Item = artifacts.require("Item");
const Market = artifacts.require("Market");

module.exports = async function (deployer) {
    await deployer.deploy(
        QBXM,
        "0x8C58549D7ffE044Ba25041a2c997A409d4857C83"
    );

    await deployer.deploy(
        Item,
        "0x8C58549D7ffE044Ba25041a2c997A409d4857C83"
    );

    const qbxm = await QBXM.deployed()
    const item = await Item.deployed()

    await deployer.deploy(
        Market,
        qbxm.address,
        item.address,
        "0x8C58549D7ffE044Ba25041a2c997A409d4857C83"
    );
};
