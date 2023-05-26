//SPDX-License-Identifier: MIT

pragma solidity ^0.8.14;

/*Make contract for room's reservation, with some properties:
1. Pay for a room that wil be occupied.
2. Create structure or variable for the status of the room (free or not)
3. At first the room will be free.
4. A fonction to occupied and pay th room. Send the event with the essential information
5. The condition to reservation is a free room.*/

contract HotelRoom{

    address payable private owner;
    bool statusRoomFree;

    event successBook(address _booker, uint valueRoom);

    constructor () {
        statusRoomFree = true;
        owner = payable(msg.sender);
    }

    modifier costs(uint costRoom){
        require(msg.value >= costRoom, "That's not enough");
        _;
    }
    modifier roomFree(){
        require(statusRoomFree==true,"Sorry, the room is taken");
        _;
    }

    function Book() public payable costs(1 ether) roomFree{
       
        //Call function to make the transaction
        (bool sent, bytes memory data) = owner.call{value:msg.value}("");

        require(sent);
        statusRoomFree = false;

        //Call the event
        emit successBook(msg.sender, msg.value);

    }
    function viewStatus() external view returns (bool){
        return statusRoomFree;

    }
}