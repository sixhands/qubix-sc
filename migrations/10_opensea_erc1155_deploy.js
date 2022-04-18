const TokenERC1155 = artifacts.require("TokenERC1155");

module.exports = async function (deployer) {
    deployer.deploy(TokenERC1155);
}