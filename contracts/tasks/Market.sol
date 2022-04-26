// contracts/tasks/Market.sol
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./QBXM.sol";
import "./Item.sol";

contract Market {

    QBXM internal _QBXC;
    Item internal _Item;

    address public ekosystem;
    modifier onlyEko() {
        require(msg.sender == ekosystem, "only ekosystem");
        _;
    }

    constructor(
        QBXM tokenContract,
        Item itemContract,
        address ekosystemAddress) {

        ekosystem = ekosystemAddress;
        _QBXC = tokenContract;
        _Item = itemContract;
    }

    function sellItem(
        address seller,
        address buyer,
        uint256 itemPrice,
        uint256 itemId) public returns (bool) {

        require(seller == _Item.ownerOf(itemId), "seller is not an owner of the item");
        require(_QBXC.balanceOf(buyer) >= itemPrice, "buyer doesn't have enough tokens");

        _QBXC.increaseAllowance(buyer, itemPrice);
        _QBXC.transferFrom(buyer, seller, itemPrice);

        _Item.approve(buyer, itemId);
        _Item.transferFrom(seller, buyer, itemId);

        return true;
    }
}
