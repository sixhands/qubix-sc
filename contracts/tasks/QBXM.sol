// contracts/tasks/QBXC.sol
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract QBXM is ERC20, AccessControl {
    using SafeMath for uint;

    // Wallet: qubix test 2
    bytes32 public constant EKO_ROLE = keccak256("EKO_ROLE");

    address public ekoAddress;

    constructor(address eko) ERC20("Qubix infinity fungible token", "QBXC") {
        _setupRole(EKO_ROLE, eko);

        ekoAddress = eko;

        mint(1000000 * 10**uint256(decimals()));
    }

    function mint(uint256 amount) public onlyRole(EKO_ROLE) {
        _mint(msg.sender, amount);
    }

    function getReward(
        address roomOwner,
        address[] calldata winners,
        uint256 playersAmount,
        uint256 ticketsAmount,
        uint256 ticketCost
    ) public onlyRole(EKO_ROLE) {

        //playersAmount * ticketsAmount * ticketCost * 0.9 / winners.length;
        uint256 reward = 1;
        bool success;
        (success, reward) = reward.tryMul(playersAmount);
        (success, reward) = reward.tryMul(ticketsAmount);
        (success, reward) = reward.tryMul(ticketCost);
        (success, reward) = reward.tryMul(9);
        (success, reward) = reward.tryDiv(winners.length);
        (success, reward) = reward.tryDiv(10);
        require(success, "Something went wrong during reward calculation..");

        increaseAllowance(ekoAddress, reward.mul(winners.length));

        for (uint256 i = 0; i < winners.length; i++) {
            transferFrom(ekoAddress, winners[i], reward);
        }

        increaseAllowance(ekoAddress, reward.div(18));
        transferFrom(ekoAddress, roomOwner, reward.div(18));
    }

    function myBalance() public view returns (uint256 balance) {
        return balanceOf(msg.sender);
    }
}
