// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract CustomerBankAccount {
    address public owner;
    mapping(address => uint256) private balances;

    event Deposit(address indexed customer, uint256 amount);
    event Withdrawal(address indexed customer, uint256 amount);

    constructor() {
        owner = msg.sender;
    }

    // 1. Deposit money
    function deposit() external payable {
        require(msg.value > 0, "Deposit amount must be greater than 0");
        balances[msg.sender] += msg.value;
        emit Deposit(msg.sender, msg.value);
    }

    // 2. Withdraw money
    function withdraw(uint256 _amount) external {
        require(_amount > 0, "Withdrawal amount must be greater than 0");
        require(balances[msg.sender] >= _amount, "Insufficient balance");

        balances[msg.sender] -= _amount;
        (bool success, ) = msg.sender.call{value: _amount}("");
        require(success, "Transfer failed");

        emit Withdrawal(msg.sender, _amount);
    }

    // 3. Show balance
    function getBalance() external view returns (uint256) {
        return balances[msg.sender];
    }

    // Fallback to prevent accidental ETH transfers
    fallback() external payable {
        revert("Use deposit() function instead");
    }

    receive() external payable {
        revert("Use deposit() function instead");
    }
}