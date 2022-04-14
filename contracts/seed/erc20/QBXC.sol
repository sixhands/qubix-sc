// contracts/seed/erc20/QBXC.sol
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract QBXC is ERC20, Ownable, AccessControl {

    bytes32 public constant SEED_ROLE = keccak256("SEED_ROLE");

    address private _seedContractAddress = address(0);
    uint256 private _seedContractAmount = 0;

    constructor() ERC20("QBXC", "QBXC") {
        _mint(msg.sender, 1000000000 * 10**uint256(decimals()));
    }

    function setSeedRole(address seedAddress) public onlyOwner {
        _setupRole(SEED_ROLE, seedAddress);
    }

    function setSeedParameters(address seedAddress, uint256 seedAmount) public onlyRole(SEED_ROLE) {
        _seedContractAddress = seedAddress;
        _seedContractAmount = seedAmount;
    }

    function _isSeedContract(address to) private view returns (bool) {
        return _seedContractAddress != address(0) && _seedContractAddress == to;
    }

    function _isTokenAmountValid(uint256 amount) private view returns (bool) {
        return _seedContractAmount != 0 && _seedContractAmount == amount;
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual override {
        super._beforeTokenTransfer(from, to, amount);

        // if transfer to seed contract, but amount of tokens is not valid - revert transaction
        if (_isSeedContract(to) && !_isTokenAmountValid(amount)) {
            revert("QBXC: amount of tokens is not valid");
        }
    }
}
