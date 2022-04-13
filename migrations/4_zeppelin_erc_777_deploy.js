const QBXC777 = artifacts.require("QBXC777");

require('@openzeppelin/test-helpers/configure')({ provider: web3.currentProvider, environment: 'truffle' });

const { singletons } = require('@openzeppelin/test-helpers');

const name = "QBXC777";
const symbol = "Q777"
const defaultOperators = [];

module.exports = async function (deployer, network, accounts) {
    if (network === 'ganache') {
        // In a test environment an ERC777 token requires deploying an ERC1820 registry
        await singletons.ERC1820Registry(accounts[0]);
    }
    deployer.deploy(QBXC777, name, symbol, defaultOperators);
};
