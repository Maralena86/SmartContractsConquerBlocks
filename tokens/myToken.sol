//SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.14;

import "./ERC20.sol";


import "@openzeppelin/contracts/access/AccessControl.sol";

contract MyToken is ERC20, AccessControl
{
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    bytes32 public constant BURNER_ROLE = keccak256("BURNER_ROLE");

    constructor() ERC20("MyminiToken", "MnT", 10000000000000000000000){
        _grantRole(MINTER_ROLE, msg.sender);
        _grantRole(BURNER_ROLE, msg.sender);
    }

    function mintToken () public onlyRole(MINTER_ROLE) {   
        _mint(msg.sender, 1000000000000000000000);
    }

    function burnTokens()  public onlyRole(BURNER_ROLE){
        _burn(msg.sender, 1000000000000000000000);
    }

}