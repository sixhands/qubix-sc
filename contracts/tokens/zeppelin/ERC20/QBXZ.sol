// contracts/token/zeppelin/ERC20/QBXZ.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract QBXZ is ERC20 {
    constructor(uint256 initialSupply) ERC20("Qubix", "QBXZ") {
        _mint(msg.sender, initialSupply);
    }
}
