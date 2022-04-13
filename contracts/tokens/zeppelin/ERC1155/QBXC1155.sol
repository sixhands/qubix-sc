// contracts/token/zeppelin/ERC1155/ERC1155.sol
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract QBXC1155 is ERC1155 {
    uint256 public constant QBXM = 0;
    uint256 public constant SOME_ASSET = 1;
    uint256 public constant WALLPAPER = 2;
    constructor() ERC1155("https://ipfs.io/ipfs/bafybeigku2khactf665hdczzugi3voay54q45g7knxgbxhufkxvoi5jlwi/{id}.json") {
        _mint(msg.sender, QBXM, 10**24, "");
        _mint(msg.sender, SOME_ASSET, 1, "");
        _mint(msg.sender, WALLPAPER, 1, "");
    }

    function uri(uint256 _tokenid) override public pure returns (string memory) {
        return string(
            abi.encodePacked(
                "https://ipfs.io/ipfs/bafybeigku2khactf665hdczzugi3voay54q45g7knxgbxhufkxvoi5jlwi/",
                Strings.toString(_tokenid),".json"
            )
        );
    }
}
