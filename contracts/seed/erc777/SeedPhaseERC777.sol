// conztracts/seed/erc777/SeedPhaseERC777.sol
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC777/IERC777Recipient.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "./TokenERC777.sol";

contract SeedPhaseERC777 is IERC777Recipient, Ownable {
    using SafeMath for uint;

    // Setting up registry
    IERC1820Registry internal constant _ERC1820_REGISTRY = IERC1820Registry(0x1820a4B7618BdE71Dce8cdc73aAB6C95905faD24);
    // Mapping of investors addresses to amount of tokens, that contract should send them
    mapping (address => uint256) private _investorsTokensToSend;
    // Addresses array of investors wallets
    address[] private _investorsAddresses;
    // Total number of tokens, that contract will send to investors
    uint256 private _promisedTokensAmount;
    // Percent of tokens, that contract already sent to investors
    uint256 private _percentagePaid;
    // Is contract already receive tokens
    bool private _isTokenReceived;
    // ERC-777 token address
    TokenERC777 private _token;

    constructor(
        TokenERC777 token,
        uint256[] memory investorsTokens,
        address[] memory investorsAddresses) {

        _isTokenReceived = false;
        _percentagePaid = 0;
        _token = token;

        // Setting up mapping of addresses investor and tokens for them
        for (uint i = 0; i < investorsAddresses.length; i++) {
            _investorsTokensToSend[investorsAddresses[i]] = investorsTokens[i];
        }
        _investorsAddresses = investorsAddresses;

        // Setting up total tokens amount
        for (uint i = 0; i < _investorsAddresses.length; i++) {
            _promisedTokensAmount += _investorsTokensToSend[_investorsAddresses[i]];
        }
        _promisedTokensAmount = _promisedTokensAmount * 10 ** uint256(_token.decimals());

        // register interface
        _ERC1820_REGISTRY.setInterfaceImplementer(address(this), keccak256("ERC777TokensRecipient"), address(this));
    }

    function tokensReceived(
        address operator,
        address from,
        address to,
        uint256 amount,
        bytes calldata userData,
        bytes calldata operatorData
    ) external override {

        require(msg.sender == address(_token), "invalid token");

        if (_isTokenReceived || amount != _promisedTokensAmount) {
            revert("tokens already received or amount is not valid");
        }
        _isTokenReceived = true;
    }

    function isTokenReceived() public view returns (bool) {
        return _isTokenReceived;
    }

    function transferToInvestors(uint256 percentage) public onlyOwner {
        require(
            isPercentageValid(percentage),
            string(abi.encodePacked(
                "percentage is not valid, you can send only ",
                Strings.toString(100 - _percentagePaid),
                " percents"
            ))
        );

        require(_token.balanceOf(address(this)) > 0, "contract don't have any tokens");

        for (uint i = 0; i < _investorsAddresses.length; i++) {

            uint256 tokensToSend = percentage.mul(_investorsTokensToSend[_investorsAddresses[i]]).div(100);
            tokensToSend = tokensToSend * 10 ** uint256(_token.decimals());

            require(_token.transfer(_investorsAddresses[i], tokensToSend),
                "something went wrong during token transfer to investor");
        }

        _percentagePaid += percentage;
    }

    function getTokensAmount() public view returns (uint256) {
        return _token.balanceOf(address(this));
    }

    function getPromisedTokensAmount() public view returns (uint256) {
        return _promisedTokensAmount;
    }

    function isPercentageValid(uint256 percentage) private view returns (bool) {
        return percentage > 0 && percentage + _percentagePaid <= 100;
    }
}
