// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "../tokens/zeppelin/ERC20/QBXC20.sol";

contract StakingPrototype is Ownable {
    enum StakingStatus {
        OPEN,
        CLOSED,
        COMPLETED,
        TERMINATED
    }

    StakingStatus public status;

    event Staked(address indexed _from, uint256 _value);

    event Withdraw(address indexed _from, uint256 _value);

    event StakingComplete(uint256 _amountStaked);

    mapping(address => uint256) public stakedBalances;

    address[] public stakers;

    mapping(address => bool) internal _userHasStaked;

    uint256 private constant _threshold = 1 ether;

    QBXC20 internal _QBXC;

    constructor() {
        _QBXC = new QBXC20();
        status = StakingStatus.OPEN;
    }

    modifier onlyWhenOpen() {
        require(status == StakingStatus.OPEN, "staking must be open");
        _;
    }

    modifier onlyWhenClosed() {
        require(status == StakingStatus.CLOSED, "staking isn`t closed");
        _;
    }

    modifier onlyWhenComplete() {
        require(status == StakingStatus.COMPLETED, "staking isn`t complete yet");
        _;
    }

    modifier whenNotOpen() {
        require(status != StakingStatus.OPEN, "staking must not be open");
        _;
    }

    receive() external payable {
        _stake();
    }

    fallback() external payable {
        _stake();
    }

    function redeemStakedAmount() external onlyOwner onlyWhenComplete {
        address payable owner = payable(owner());
        _transfer(owner, address(this).balance);
    }

    function terminateContract() external onlyOwner {
        _QBXC.transferOwnership(owner());
        status = StakingStatus.TERMINATED;
    }

    function stake() public pure {
        _stake;
    }

    function getTotalStakedAmount() public view returns (uint256) {
        uint256 totalAmount = 0;
        for (uint i = 0; i < stakers.length; i++) {
            totalAmount += stakedBalances[stakers[i]];
        }

        return totalAmount;
    }

    function withdraw() public onlyWhenClosed {
        uint256 stakedAmount = stakedBalances[msg.sender];

        require(
            stakedAmount >= address(this).balance,
            "Don`t have enough currency, can`t issue withdrawal"
        );
        require(
            stakedAmount > 0,
            "Can`t withdraw. There is no any of staked amount"
        );

        (bool success, ) = address(msg.sender).call{value: stakedAmount}("");
        require(success, "unable to complete withdrawal");

        stakedBalances[msg.sender] = 0;

        emit Withdraw(msg.sender, stakedAmount);
    }

    function closeStaking() public onlyOwner {
        status = StakingStatus.CLOSED;
    }

    function completeStaking() public onlyOwner {
        uint256 balance = getTotalStakedAmount();

        require(
            balance >= _threshold,
            "staked amount has not reached threshold"
        );

        for (uint256 i = 0; i < stakers.length; i++) {
            uint256 amount = _getTokenNumToAward(stakedBalances[stakers[i]]);

            _QBXC.transfer(stakers[i], amount);

            stakedBalances[stakers[i]] = 0;
            _userHasStaked[stakers[i]] = false;
        }

        stakers = new address[](0);
        status = StakingStatus.COMPLETED;

        emit StakingComplete(balance);
    }

    function getStatus() public view returns (uint8) {
        return uint8(status);
    }

    function getNumberOfStakers() public view returns (uint256) {
        return stakers.length;
    }

    function getUserStakedAmount(address _user) public view returns (uint256) {
        return stakedBalances[_user];
    }

    function restartStaking() public onlyOwner whenNotOpen {
        status = StakingStatus.OPEN;
    }

    function tokenBalanceOf(address _account) public view returns (uint256) {
        return _QBXC.balanceOf(_account);
    }

    function _stake() internal onlyWhenOpen {
        if (_userHasStaked[msg.sender] == false) {
            stakers.push(msg.sender);
            _userHasStaked[msg.sender] == true;
        }

        stakedBalances[msg.sender] += msg.value;

        emit Staked(msg.sender, msg.value);
    }

    function _getTokenNumToAward(uint256 _amount) private pure returns (uint256) {
        return 1000 * _amount;
    }

    function _transfer(address payable _to, uint256 _amount) private {
        (bool success, ) = _to.call{value: _amount}("");
        require(success, "failed to send Ether");
    }
}
