//SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.14;

contract Visibility{
    uint public x = 15;
    uint internal y = 10;
    uint private z = 20;

    //acces everywhere 
    function get_y() public view returns(uint){
        return get_var_y();
    }
    //Only acces in contract
    function get_var_y() private view returns (uint){
        return y;
    }
    //Heritable  and contract's call
    function get_x () internal view returns (uint){
        return x;
    }
    //Calls outside contract
    function get_var_x() external view returns (uint){
        return x;
    }
    //Pure doesn't acces to blockchain data
    function get_add(uint a, uint b) public pure returns (uint){
        return a+b;
    }
}
//Acces to extrnal and internal fonction. Heritage
contract A is Visibility{
    uint public numberX = get_x();
}


//Acces to external and public fonctions 
contract B{
    Visibility contract1 = new Visibility();

    uint public var1 = contract1.get_y();
    uint public var2 = contract1.get_var_x();
    uint public var3 = contract1.get_add(3,5);
}