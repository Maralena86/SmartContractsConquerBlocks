//SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

import "@openzeppelin/contracts@4.8.1/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts@4.8.1/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts@4.8.1/token/ERC1155/extensions/ERC1155Supply.sol";


contract NFTCollection1155 is ERC1155Supply, Ownable{
    uint price = 0.05 ether;
    uint whiteListPrice = 0.02 ether;
    
    uint maxSupply = 1;

    bool public whiteListStatus = true;

    mapping (address => bool) whiteListMembers;

    constructor () ERC1155("https://token-cdn-domain"){} 

    function uri (uint _id) public view virtual override returns(string memory){
        require(exists(_id), "Non existent token");
        return string(abi.encodePacked(super.uri(_id), Strings.toString(_id), ".json"));
    }

    function whiteList(uint id) public payable {
        require(whiteListStatus, "White list is closed");       
        require(whiteListMembers[msg.sender], "You are not allowed");

        mint(id, whiteListPrice);
    }

    function normalMint (uint id) public payable{
        require(!whiteListStatus, "White list is open");
        mint(id, price);
    }

    function mint(uint _id, uint _price) internal {
        require(msg.value>=_price, "Not enough ethers");
        require(totalSupply(_id)+1 <= maxSupply, "Minted out");
        _mint(msg.sender, _id, 1, ""); 

         uint reaminder = msg.value - _price;
        payable(msg.sender).transfer(reaminder);

    }

    function mintBach (uint[] memory ids, uint[] memory amounts) public payable{
        require(!whiteListStatus, "White list is open");
        uint totalPrice;
        for(uint i=0; i<ids.length; i++){
            totalPrice += amounts[i];
        }
        require(msg.value>=totalPrice, "Not enough ethers");

        for(uint i=0; i<ids.length; i++){
           require(totalSupply(ids[i])+amounts[i]<=maxSupply, "Minted out");
        }
        _mintBatch(msg.sender, ids, amounts, "");

         uint reaminder = msg.value - totalPrice;
        payable(msg.sender).transfer(reaminder);
    }

    function addMembers(address [] memory _members) external onlyOwner {
        for(uint i = 0; i < _members.length; i++){
            whiteListMembers[_members[i]] = true;
        }
    }

    function changeWhiteListStatus(bool _status) external onlyOwner {
        whiteListStatus = _status;
    }

    function withdraw () external onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }

}