//SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract Factory {
    mapping(address => address) public user_contract;
    function factory() public {
        address secondContract = address(new Contract(msg.sender, address(this)));
        user_contract[msg.sender] = secondContract;
    }
}
contract Contract {
    struct Data {
        address owner;
        address parent;
    }
    Data public data;
    constructor(address _owner, address _parent){
        data.owner = _owner;
        data.parent = _parent;
    }
}