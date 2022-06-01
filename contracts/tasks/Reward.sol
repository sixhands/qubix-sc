// contracts/tasks/Reward.sol
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./QBXM.sol";

contract Reward is Ownable {
    using SafeMath for uint;

    mapping(address => uint256) private claims;
    QBXM private immutable token;

    address public immutable ekoAddress;

    constructor(address _ekoAddress, QBXM _token) {
        ekoAddress = _ekoAddress;
        token = _token;
    }

    function getReward(
        address roomOwner,
        address[] calldata winners,
        uint256 playersAmount,
        uint256 ticketsAmount,
        uint256 ticketCost
    ) public onlyOwner {

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

//        increaseAllowance(ekoAddress, reward.mul(winners.length));

        for (uint256 i = 0; i < winners.length; i++) {
            setClaim(winners[i], reward);
        }

//        increaseAllowance(ekoAddress, reward.div(18));
        setClaim(roomOwner, reward.div(18));
    }

    function transferClaimedTokens(address _player, uint256 _amountToTransfer) public onlyOwner {
        require(_player != address(0), "transfer to the zero address");
        require(token.balanceOf(address(this)) > _amountToTransfer, "insufficient balance of contract");

        token.approve(address(this), _amountToTransfer);
        token.transferFrom(address(this), _player, _amountToTransfer);
    }

    function viewClaimedTokens(address _player) public view returns (uint256) {
        return claims[_player];
    }

    function setClaim(address _player, uint256 amountToClaim) private {
        require(_player != address(0), "claim to the zero address");
        claims[_player] += amountToClaim;
    }
}
