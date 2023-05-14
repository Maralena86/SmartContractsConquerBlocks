//SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.14;

mapping (address => uint) balance;

function addMoney(uint money) public returns(balance){
    balance = balance + money
    return balance;
}