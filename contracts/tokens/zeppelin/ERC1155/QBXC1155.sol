// contracts/token/zeppelin/ERC1155/ERC1155.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";

contract QBXC1155 is ERC1155 {
    uint256 public constant CRYSTALS = 0;
    uint256 public constant QBXC = 1;
    uint256 public constant CUBE_FACE = 2;
    uint256 public constant SKIN = 3;

    constructor() ERC1155("https://backend/api/item/{id}.json") {
        _mint(msg.sender, CRYSTALS, 10**21, "");
        _mint(msg.sender, QBXC, 10**21, "");
        _mint(msg.sender, CUBE_FACE, 100, "");
        _mint(msg.sender, SKIN, 10**9, "");
    }
}
