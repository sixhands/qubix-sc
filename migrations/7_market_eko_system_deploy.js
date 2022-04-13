const QBXC = artifacts.require("QBXC");
const Item = artifacts.require("Item");
const Market = artifacts.require("Market");

module.exports = async function (deployer) {
    await deployer.deploy(
        QBXC,
        "0x8C58549D7ffE044Ba25041a2c997A409d4857C83"
    );

    await deployer.deploy(
        Item,
        "0x8C58549D7ffE044Ba25041a2c997A409d4857C83"
    );

    const qbxc = await QBXC.deployed()
    const item = await Item.deployed()

    await deployer.deploy(
        Market,
        qbxc.address,
        item.address,
        "0x8C58549D7ffE044Ba25041a2c997A409d4857C83"
    );
};
