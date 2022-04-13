// contracts/token/zeppelin/ERC1155/ERC1155.sol
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract QBXC1155 is ERC1155 {
    //uint256 public constant QBXC = 0;
    uint256 public constant SOME_ASSET = 1;

    constructor() ERC1155("https://ipfs.io/ipfs/bafybeigfs3ikzbwsy7aopvzf6v4dms2tehz6pgsjxy2lyixdfjuzvmwm2a/{id}.json") {
        //_mint(msg.sender, QBXC, 10**24, "");
        _mint(msg.sender, SOME_ASSET, 1, "");
    }

    function uri(uint256 _tokenid) override public pure returns (string memory) {
        return string(
            abi.encodePacked(
                "https://ipfs.io/ipfs/bafybeigfs3ikzbwsy7aopvzf6v4dms2tehz6pgsjxy2lyixdfjuzvmwm2a/",
                Strings.toString(_tokenid),".json"
            )
        );
    }
}
