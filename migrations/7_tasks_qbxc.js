const QBXC = artifacts.require("QBXC");

module.exports = async function (deployer) {
    await deployer.deploy(
        QBXC,
        "0xCd552D7066da507FD9870a82A319953f713d542B",
        "0x8C58549D7ffE044Ba25041a2c997A409d4857C83"
    );
};
