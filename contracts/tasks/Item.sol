// contracts/tasks/Item.sol
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract Item is ERC721URIStorage {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIds;

    // Wallet: qubix test 2
    bytes32 public constant EKO_ROLE = keccak256("EKO_ROLE");

    address public ekoAddress;
    modifier onlyEko() {
        require(msg.sender == ekoAddress, "only eko");
        _;
    }

    constructor(address eko) ERC721("Qubix item", "QItem") {
        ekoAddress = eko;
    }

    function giveItem(
        address player,
        string memory tokenURI) public onlyEko returns (uint256) {

        _tokenIds.increment();

        uint256 newItemId = _tokenIds.current();
        _mint(player, newItemId);
        _setTokenURI(newItemId, tokenURI);

        return newItemId;
    }
}
