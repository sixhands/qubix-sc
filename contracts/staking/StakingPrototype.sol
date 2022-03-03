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

    modifier OnlyWhenOpen() {
        require(status == StakingStatus.OPEN, "staking must be open");
        _;
    }

    modifier OnlyWhenClosed() {
        require(status == StakingStatus.CLOSED, "staking isn`t closed");
        _;
    }

    modifier OnlyWhenComplete() {
        require(status == StakingStatus.COMPLETED, "staking isn`t complete yet");
        _;
    }

    function stake() public {
        _stake;
    }

    function _stake() internal OnlyWhenOpen {
        if (_userHasStaked[msg.sender] == false) {
            stakers.push(msg.sender);
            _userHasStaked[msg.sender] == true;
        }

        stakedBalances[msg.sender] += msg.value;

        emit Staked(msg.sender, msg.value);
    }

    function getTotalStakedAmount() external view returns (uint256) {
        uint256 totalAmount = 0;
        for (uint i = 0; i < stakers.length; i++) {
            totalAmount += stakedBalances[stakers[i]];
        }

        return totalAmount;
    }

    function withdraw() public OnlyWhenClosed {
        uint256 stakedAmount = stakedBalances[msg.sender];

        require(
            stakedAmount >= address(this).balance,
            "Don`t have enough currency, can`t issue withdrawal"
        );
        require(
            stakedAmount > 0,
            "Can`t withdraw. There is no any of staked amount"
        );


    }
}
