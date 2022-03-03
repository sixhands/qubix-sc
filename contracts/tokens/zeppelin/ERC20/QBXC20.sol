// contracts/token/zeppelin/ERC20/QBXZ.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract QBXC20 is ERC20 {
    constructor() ERC20("QBXC20", "Q20") {
        _mint(msg.sender, 1000 * 10**uint256(decimals()));
    }
}
