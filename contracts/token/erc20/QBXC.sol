// contracts/token/erc20/QBXC.sol
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract TokenERC20 is ERC20 {
    constructor() ERC20("QBXC", "QBXC") {
        _mint(msg.sender, 1000000000 * 10**uint256(decimals()));
    }
}
