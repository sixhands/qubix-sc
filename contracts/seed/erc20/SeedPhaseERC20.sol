// contracts/seed/erc20/SeedPhaseERC20.sol
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./QBXC.sol";

contract SeedPhaseERC20 is Ownable {
    using SafeMath for uint;

    mapping (address => uint256) private _investorsBalances;
    address[] private _investorsAddresses;
    QBXC private _token;

    constructor(
        QBXC token,
        uint256[] memory investorsTokens,
        address[] memory investorsAddresses) {

        for (uint i = 0; i < investorsAddresses.length; i++) {
            _investorsBalances[investorsAddresses[i]] = investorsTokens[i];
        }
        _investorsAddresses = investorsAddresses;
        _token = token;
    }

    function setSeedParametersToToken() public onlyOwner {
        _token.setSeedParameters(address(this), getPromisedTokensAmount());
    }

    function transferToInvestors(uint256 percentage) public onlyOwner {
        require(isPercentageValid(percentage), "percentage is not valid");
        require(_token.balanceOf(address(this)) > 0, "contract don't have any tokens");

        for (uint i = 0; i < _investorsAddresses.length; i++) {

            uint256 tokensToSend = percentage.mul(_investorsBalances[_investorsAddresses[i]]).div(100);

            _investorsBalances[_investorsAddresses[i]] =
            _investorsBalances[_investorsAddresses[i]] - tokensToSend;

            require(_token.transfer(_investorsAddresses[i], tokensToSend),
                "something went wrong during token transfer to investor");
        }
    }

    function getPromisedTokensAmount() public view returns (uint256) {
        uint256 totalAmount = 0;
        for (uint i = 0; i < _investorsAddresses.length; i++) {
            totalAmount += _investorsBalances[_investorsAddresses[i]];
        }

        return totalAmount;
    }

    function getTokensAmount() public view returns (uint256) {
        return _token.balanceOf(address(this));
    }

    function isPercentageValid(uint256 percentage) private pure returns (bool) {
        return percentage > 0 && percentage <= 100;
    }
}
