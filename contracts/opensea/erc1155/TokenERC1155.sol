// contracts/opensea/erc1155/TokenERC1155.sol
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract TokenERC1155 is ERC1155 {

    uint256 public constant TED = 1;

    constructor() ERC1155("https://hub.qubixinfinity.io/contracts/{id}.json") {
        _mint(msg.sender, TED, 1, "");
    }

    function uri(uint256 _tokenId) override public pure returns (string memory) {
        return string(abi.encodePacked(
            "https://hub.qubixinfinity.io/contracts/",
            Strings.toString(_tokenId),
            ".json"
        ));
    }
}
