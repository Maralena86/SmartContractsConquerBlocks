//SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Lottery is ERC20, Ownable{
    address public nft;
    address public winner;

    mapping(address =>address)user_contract;

    constructor() ERC20("Lottostrinette", "LTT"){
        _mint(address(this), 1000);
        nft = address(new NFTs());
    }
    function tokenPrice(uint _numToken) internal pure returns (uint){
        return _numTokens * 0.5 ether;
    }
    function mint(uint _numTokens) public onlyOwner {
        _mint(address(this), _numTokens);
    }
    function userRegistrer() internal{
        address secondContract = address (new Tickets(msg.sender), address(this), nft);
        user_contract[msg.sender] = SecondContract;
    }
    function userInfo (address _user) public view returns(address){
        return user_contract[_user];
    }
    function buyTokens(uint _numTokens) public payable {
        if(user_contract(msg.sender)== address[0]){
            userRegistrer();
        }
        require (balanceOf(address(this)>= _numTokens, "Not enough tokens"));
        uint pricz = tokenPrice(_numTokens);
        require(msg.value >= price, "Not enough ethers");
        uint returnValue = msg.value - price;
        payable(msg.sender).transfer(returnValue);

        _transfer(address(this), msg.sender, _numTokens);
    }
}

contract NFTs is ERC721 {
    constructor() ERC721("LotoTicket", "LTK"){

    }
    function safeMint(address _owner, uint _ticketID) internal{
        _safeMint(_owner, _ticketID);
    }
}

contract Tickets{
    struct Data{
        address owner,
        address lotteryContract, 
        address NFTContract,
        address userContract
    }

    Data public userData;

    constructor(address _owner, address _lotteryContract, address _NFTContract){
        userData = Data (_owner, _lotteryContract, _NFTContract, address(this));
    }

}
