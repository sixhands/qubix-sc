const MarketplaceToken = artifacts.require("MarketplaceToken");

module.exports = async function (deployer) {
    deployer.deploy(
        MarketplaceToken,
        "0x7909c99936C3a41221f7837d27645c87A1D22B1A",
        [1, 2, 3, 4, 5, 6, 7],
        [1024, 1024, 1024, 512, 512, 256, 32]
    );
}