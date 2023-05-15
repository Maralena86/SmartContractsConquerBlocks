//SPDX-License-Identifier: MIT

pragma solidity ^0.8.14;

/*
 It is msg.data empty??
    A.NO=> It calls the fallback's function
    B. YES=> Ther is a recive() function??
        B.a. Yes=> It calls receive()
        B.b. No => It calls fallback()
*/

contract Receive_Fallback{
    //Event
    event info(string _function, address _sender, uint _amount, bytes data);

    fallback() external payable
    {
        emit info("fallback", msg.sender, msg.value, msg.data);
    }
    receive() external payable
    {
        emit info("receive", msg.sender, msg.value, "");
    }
}
