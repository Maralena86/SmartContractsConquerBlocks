//SPDX-License-Identifier: MIT

pragma solidity 0.8.14;

contract EthSender{


    //Events
    event sendStatus (bool success);
    event callStatus (bool succes, bytes data);


    constructor () payable {}
    receive () external payable {}


    //Transfert
    function usingTransfert (address payable _to) public payable
    {
        _to.transfer(1 ether);  

    }

    //Send
    function usingSend (address payable _to) public payable
    {
        bool success = _to.send(1 ether);
        emit sendStatus(success);
    }

    //Call
    function usingCall (address payable _to) public payable
    {
        (bool success, bytes memory data) = _to.call{value: 1 ether}("");
        emit callStatus(success, data);
    }



}
contract EthReceiver{
    //Event

    event transactionInfo(uint amount, uint gas);
    receive () external payable {
        emit transactionInfo (address(this).balance, gasleft());
    }

}