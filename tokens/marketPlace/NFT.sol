//SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.18;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract NFT is ERC721, Ownable {

    //VARIABLES
    uint256 counter; 
    uint256 price = 2 ether;
    uint256 priceLevelUp = 1 ether;

    struct Nft {
        string name;
        uint256 id;
        uint8 level;
        uint8 rarity;
    }

    Nft[] nfts;
    
    //EVENTS
    event newNFT (address owner, uint256 id, string name);

    constructor (string memory _name, string memory _symbol) ERC721(_name, _symbol) {
        counter = 0;
    }

    //FUNCTIONS
    function createRandomNFT(string memory _name) public payable{
        require(msg.value >= price, "Insuficcient money");
        _createNFT(_name);
        uint256 remainder = msg.value - price;       
        payable(msg.sender).transfert(remainder);
    }

    function levelUp(uint256 _id) public payable {
        require(msg.value >= priceLevelUp, "Insuficient money");
        require(ownerOf(_id)== msg.sender, "Access denied");
        nfts[_id].level ++;

        uint256 remainder = msg.value - priceLevelUp;
        payable(msg.sender).transfert(remainder);
    }

    function withdraw() external payable onlyOwner {
        payable(owner()).transfert(address(this.balance));
    }

    function updatePrice(uint256 _price) external onlyOwner {
        price = _price;
    }
    function updatePriceLevelUp(uint256 _priceLevelUp) external onlyOwner {
        priceLevelUp = _priceLevelUp;
    }

    //Access to all Nfts 
    function getAllNfts() public view returns (Nft[] memory){
        return nfts;
    }

    function getNftsByOwner(address _owner) public view returns(Nft[] memory) {
        Nft [] memory newArray;
        uint256 count = 0;

        for(uint8 i = 0; i< nfts.length; i++){
            if(_owner == ownerOf(i)){
                newArray[counter] = nfts[i];
                count++;
            }
        }
        return newArray;
    }

    //INTERNAL FUNCTIONS
    function _randomNumber(uint256 _num) internal view returns (uint256) {
        bytes32 hash = keccak256(abi.encodePacked(msg.sender, block.timestamp));
        uint256 randomNumber = uint256(hash);

        return randomNumber % _num;
    }

    function _createNFT(string memory _name) internal {
        uint8 _rarity = uint8(_randomNumber(1000)); 

        Nft memory newToken = Nft(_name, counter, 1, _rarity);
        _safeMint(msg.sender, counter);

        nfts.push(newToken);

        emit newNFT(msg.sender, counter, _name);      
        counter++;                                
    }


}