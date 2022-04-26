// contracts/opensea/erc1155/TokenERC1155.sol
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract TokenERC1155 is ERC1155 {

    uint256 public constant BLOODLOV = 1;
    uint256 public constant LOMIX = 2;
    uint256 public constant BULLER = 3;
    uint256 public constant GOLDHUNTER = 4;
    uint256 public constant POWERF = 5;
    uint256 public constant SILEN = 6;
    uint256 public constant SOLARY = 7;

    constructor() ERC1155("https://hub.qubixinfinity.io/contracts/{id}.json") {
        _mint(msg.sender, BLOODLOV, 1024, "");
        _mint(msg.sender, LOMIX, 1024, "");
        _mint(msg.sender, BULLER, 1024, "");
        _mint(msg.sender, GOLDHUNTER, 512, "");
        _mint(msg.sender, POWERF, 512, "");
        _mint(msg.sender, SILEN, 256, "");
        _mint(msg.sender, SOLARY, 32, "");
    }

    function uri(uint256 _tokenId) override public pure returns (string memory) {
        return string(abi.encodePacked(
            "https://hub.qubixinfinity.io/contracts/",
            Strings.toString(_tokenId),
            ".json"
        ));
    }
}
