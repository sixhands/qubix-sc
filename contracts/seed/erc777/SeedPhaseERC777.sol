// contracts/seed/erc777/SeedPhaseERC777.sol
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC777/IERC777Recipient.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "./TokenERC777.sol";

contract SeedPhaseERC777 is IERC777Recipient, Ownable {
    using SafeMath for uint;

    // Emitted when tokens received
    event TokensReceived(address from, uint256 amount);
    // Emitted when some percentage of tokens sends to investors
    event TokensSendToInvestors(uint256 percentage);

    // Setting up registry
    IERC1820Registry internal constant ERC1820_REGISTRY = IERC1820Registry(0x1820a4B7618BdE71Dce8cdc73aAB6C95905faD24);
    // Mapping of investors addresses to amount of tokens, that contract should send to them
    mapping (address => uint256) private investorsTokensToSend;
    // Addresses array of investors wallets
    address[] private investorsAddresses;
    // Total number of tokens, that contract will send to investors
    uint256 private promisedTokensAmount;
    // Percent of tokens, that contract already sent to investors
    uint256 private percentagePaid;
    // Is contract already receive tokens
    bool private isTokenReceived;
    // ERC-777 token address
    TokenERC777 private token;

    constructor(
        TokenERC777 _token,
        uint256[] memory _investorsTokens,
        address[] memory _investorsAddresses) {

        investorsAddresses = _investorsAddresses;
        isTokenReceived = false;
        percentagePaid = 0;
        token = _token;

        // Setting up mapping of investors addresses  and tokens for them
        for (uint8 i = 0; i < investorsAddresses.length; i++) {
            investorsTokensToSend[investorsAddresses[i]] = _investorsTokens[i];
            promisedTokensAmount += investorsTokensToSend[investorsAddresses[i]];
        }
        promisedTokensAmount = promisedTokensAmount * 10 ** uint256(token.decimals());

        // register interface
        ERC1820_REGISTRY.setInterfaceImplementer(address(this), keccak256("ERC777TokensRecipient"), address(this));
    }

    function tokensReceived(
        address,
        address from,
        address,
        uint256 amount,
        bytes calldata,
        bytes calldata
    ) external override {

        require(msg.sender == address(token), "invalid token");

        if (isTokenReceived || amount != promisedTokensAmount) {
            revert("tokens already received or amount is not valid");
        }
        isTokenReceived = true;

        emit TokensReceived(from, amount);
    }

    function getIsTokenReceived() public view returns (bool) {
        return isTokenReceived;
    }

    function transferToInvestors(uint256 _percentage) public onlyOwner {
        require(
            isPercentageValid(_percentage),
            string(abi.encodePacked(
                "percentage is not valid, you can send only ",
                Strings.toString(100 - percentagePaid),
                " percents"
            ))
        );

        require(token.balanceOf(address(this)) > 0, "contract don't have any tokens");

        for (uint8 i = 0; i < investorsAddresses.length; i++) {

            uint256 tokensToSend = _percentage.mul(investorsTokensToSend[investorsAddresses[i]]).div(100);
            tokensToSend = tokensToSend * 10 ** uint256(token.decimals());

            token.send(investorsAddresses[i], tokensToSend, "");
        }

        percentagePaid += _percentage;

        emit TokensSendToInvestors(_percentage);
    }

    function getTokensAmount() public view returns (uint256) {
        return token.balanceOf(address(this));
    }

    function getPromisedTokensAmount() public view returns (uint256) {
        return promisedTokensAmount;
    }

    function isPercentageValid(uint256 _percentage) private view returns (bool) {
        return _percentage > 0 && _percentage + percentagePaid <= 100;
    }
}