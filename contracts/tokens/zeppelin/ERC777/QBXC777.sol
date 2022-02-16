// contracts/token/zeppelin/ERC777/QBXC777.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC777/ERC777.sol";

contract QBXC777 is ERC777 {
    constructor(uint256 initialSupply)
        ERC777("QBXC777", "Q777", new address[](0))
    {
        _mint(msg.sender, initialSupply, "", "");
    }
}
