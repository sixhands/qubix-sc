// conztracts/seed/erc777/TokenERC777.sol
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC777/ERC777.sol";

contract TokenERC777 is ERC777 {

    constructor(address[] memory defaultOperators) ERC777("QBXC", "QBXC", defaultOperators) {
        _mint(msg.sender, 1000000000 * 10 ** uint256(decimals()), "", "");
    }
}
