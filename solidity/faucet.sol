// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract Faucet {
    address public  owner;
    bool public isActive;

    constructor() {
        owner = msg.sender;
        isActive = true;
    }

    receive() external payable { }

    function requestEther(uint _amount) public  {
        require(isActive, "Faucet is no longer active");
        require(_amount <= 0.1 ether,  "Request exceeds faucet limit");
        require(address(this).balance >= _amount, "Insufficient funds in faucet");

        payable(msg.sender).transfer(_amount);
    }

    function withdraw(uint _amount) public onlyOwner {
        require(isActive, "Faucet is no longer active");
        require(_amount <= address(this).balance, "Insufficient funds in faucet");

        payable(owner).transfer(_amount);
    }

    function withdrawAll() public onlyOwner {
        require(isActive, "Faucet is not longer active");
        isActive = false;

        payable (owner).transfer(address(this).balance);
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner ca execute the fuction");
        _;
    }
}