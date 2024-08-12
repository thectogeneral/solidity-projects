// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract Marketplace {
    address public owner;
    uint public  itemCount = 0;

    struct Item {
        uint id;
        address payable seller;
        string name;
        string description;
        uint price;
        bool sold;
    }

    mapping (uint => Item) public  items;

    event ItemListed(uint id, address seller, string name, uint price);
    event ItemPurchased(uint id, address buyer, uint price);

    constructor() {
        owner = msg.sender;
    }

    function listItem(string memory _name, string memory _description, uint _price) public {
        require(_price > 0, "Price must be greater than zero");

        itemCount++;
        items[itemCount] = Item(itemCount, payable (msg.sender), _name, _description, _price, false);

        emit ItemListed(itemCount, msg.sender, _name, _price);
    }

    function purchaseItem(uint _id) public payable  {
        Item storage item = items[_id];
        require(_id > 0 && _id <= itemCount, "Item does not exist");
        require(msg.value == item.price, "Inccorrect Ether amount");
        require(!item.sold, "Item already sold");

        item.seller.transfer(msg.value);
        item.sold = true;

        emit ItemPurchased(_id, msg.sender, item.price);
    }
}