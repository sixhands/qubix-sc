const TokenERC20 = artifacts.require("QBXC");

module.exports = async function (deployer) {
    await deployer.deploy(
        TokenERC20
    );
};
