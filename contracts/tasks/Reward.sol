// contracts/tasks/Reward.sol
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./QBXM.sol";

contract Reward is Ownable {
    using SafeMath for uint;

    QBXM private immutable token;

    address public immutable ekoAddress;

    constructor(address _ekoAddress, QBXM _token) {
        ekoAddress = _ekoAddress;
        token = _token;
    }

    function getReward(
        address roomOwner,
        address[] calldata winners,
        uint256 ticketsAmount,
        uint256 ticketCost
    ) public onlyOwner {

        // 97% - winners, 2% - roomOwner, 1% - fees

        bool isCalculationSuccessful;

        // All reward
        uint256 allReward;
        (isCalculationSuccessful, allReward) = ticketCost.tryMul(ticketsAmount);
        (isCalculationSuccessful, allReward) = allReward.tryMul(10 ** uint256(token.decimals()));

        // Room winners reward
        uint256 winnersReward = allReward;
        (isCalculationSuccessful, winnersReward) = winnersReward.tryMul(97);
        (isCalculationSuccessful, winnersReward) = winnersReward.tryDiv(100);
        (isCalculationSuccessful, winnersReward) = winnersReward.tryDiv(winners.length);

        // Room owner reward
        uint256 roomOwnerReward = allReward;
        (isCalculationSuccessful, roomOwnerReward) = roomOwnerReward.tryMul(2);
        (isCalculationSuccessful, roomOwnerReward) = roomOwnerReward.tryDiv(100);


        require(isCalculationSuccessful, "Something went wrong during reward calculation..");

        token.increaseAllowance(ekoAddress, allReward);

        for (uint8 i = 0; i < winners.length; i++) {
            token.transfer(winners[i], winnersReward);
        }

        token.transfer(roomOwner, roomOwnerReward);
    }
}
