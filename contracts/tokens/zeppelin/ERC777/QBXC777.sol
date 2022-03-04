// conztracts/token/zeppelin/ERC777/QBXC777.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC777/ERC777.sol";

contract QBXC777 is ERC777 {
    constructor(
        string memory name,
        string memory symbol,
        address[] memory defaultOperators
    )
        ERC777(name, symbol, defaultOperators)
    {
        _mint(msg.sender, 10000 * 10 ** uint256(decimals()), "", "");
    }
}
