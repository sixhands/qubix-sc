// contracts/tasks/QBXC.sol
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract QBXM is ERC20 {
    constructor() ERC20("Qubix infinity fungible token", "QBXC") {
        _mint(msg.sender, 1000000 * 10**uint256(decimals()));
    }
}
