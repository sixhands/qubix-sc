const TokenERC20 = artifacts.require("TokenERC20");
const SeedERC20 = artifacts.require("SeedPhaseERC20");

module.exports = async function (deployer) {
    await deployer.deploy(
        TokenERC20
    );

    const tokenERC20 = await TokenERC20.deployed()

    const seed = await deployer.deploy(
        SeedERC20,
        tokenERC20.address,
        [1000, 500, 250],
        [
            "0x32289C3688CEbf515A065E7D25DC5cEFDb6E9c12",
            "0xCd552D7066da507FD9870a82A319953f713d542B",
            "0xeC097800387fE89F22297f2Eebb386bAD9ed4CC5"
        ]
    );

    await tokenERC20.setSeedRole(seed.address)
    await seed.setSeedParametersToToken()
};
