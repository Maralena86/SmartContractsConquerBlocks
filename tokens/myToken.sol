//SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.14;
import "./ERC20.sol";

contract MyToken is ERC20
{
    address owner;
    constructor() ERC20("MyminiToken", "MnT"){
        owner = msg.sender;
    }

    function mintToken () public {
        require(msg.sender ==owner, "Is not the owner");
        _mint(msg.sender, 1000000000000000000000);
    }

}