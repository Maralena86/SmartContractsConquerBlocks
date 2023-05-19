//SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.14;
//add external contract @openzepellin
import "@openzeppelin/contracts/access/Ownable.sol";


contract VendingMachine is Ownable{ 

    struct Snack{
        uint32 id;
        string name;
        uint32 quantity;
        uint8 price;
    }
    Snack [] stock;
    uint32 totalSnacks;


    //Events
    event newSnackAdded (string _name, uint8 _price);
    event snackRestocked (string _name, uint32 _quantity);
    event snackSold(string _name, uint32 _amount); 


    constructor () {
       
        totalSnacks = 0;

    }
    //The modifier permets to have a fonction that controles the owner acces
   
    //Acces to all snacks
    function getAllSnacks () external view returns (Snack [] memory _stock)
    {
        return stock;
    }

    function addNewSnack (string memory _name, uint32 _quantity, uint8 _price ) external onlyOwner 
    {
        //1Prove that the parameters are not empty
        require (bytes(_name).length!=0, "Null name");
        require (_price!=0, "Null price");
        require (_quantity != 0, "Null quantity");

        for(uint8 i = 0; i<stock.length; i++)
        {
            require(!compareStrings(_name, stock[i].name));
        }
        Snack memory newSnack = Snack (totalSnacks, _name, _quantity, _price);
        stock.push(newSnack);
        totalSnacks++;

        emit newSnackAdded(_name, _price);
    }
    
    function restoreStock (uint32 _id, uint32 _quantity) external onlyOwner
    {
        require (_quantity != 0, "Null quantity");
        require (_id < stock.length);

        stock[_id].quantity += _quantity;
        emit snackRestocked(stock[_id].name, stock[_id].quantity); 
    }

    function getMachineBalance()  external view onlyOwner returns(uint)
    {
        return address(this).balance;
    }

    function whithDraw() external onlyOwner
    {

       payable(owner()).transfer(address(this).balance);
    }

    function  buySnack(uint32 _id, uint32 _amount) external payable{
        require(_amount > 0, "Incorrect amount");
        require(stock[_id].quantity >=_amount, "Insufficient quantity");
        require(msg.value >= _amount*stock[_id].price);

        stock[_id].quantity -= _amount;
        emit snackSold(stock[_id].name, _amount);
    }

    function compareStrings(string memory a, string memory b) internal pure returns (bool)
    {
        return (keccak256(abi.encodePacked(a))) == keccak256(abi.encodePacked(b));
    }


}