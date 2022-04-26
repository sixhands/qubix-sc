const SeedPhaseERC777 = artifacts.require("SeedPhaseERC777");
const TokenERC777 = artifacts.require("TokenERC777");

require('@openzeppelin/test-helpers/configure')({ provider: web3.currentProvider, environment: 'truffle' });

const { singletons } = require('@openzeppelin/test-helpers');

module.exports = async function (deployer, network, accounts) {

    if (network === 'ganache') {
        // In a test environment an ERC777 token requires deploying an ERC1820 registry
        await singletons.ERC1820Registry(accounts[0]);
    }

    await deployer.deploy(
        TokenERC777,
        []
    );

    const token = await TokenERC777.deployed();

    await deployer.deploy(
        SeedPhaseERC777,
        token.address,
        [1000, 500, 250],
        [
            "0x32289C3688CEbf515A065E7D25DC5cEFDb6E9c12",
            "0xCd552D7066da507FD9870a82A319953f713d542B",
            "0xeC097800387fE89F22297f2Eebb386bAD9ed4CC5"
        ]
    );
};
