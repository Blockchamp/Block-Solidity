// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./Ownable.sol";
import "./NestToken.sol";

contract Payment is Ownable {
    event SendToken(address recipient, uint256 amount, address adminAddresses);
    event BuyTicket(address recipient, uint256 amount, string name);
    uint256 tokensAwarded;
    uint256 customersAwarded;

    mapping(address => uint256) public Payments;
    mapping(address => uint256) public Rewards;
    mapping(address => bool) public adminAddresses;

    NestToken public nestedToken;

    constructor(address tk) {
        nestedToken = NestToken(tk);
        adminAddresses[msg.sender] = true;
    }

    modifier onlyAdmin() {
        require(adminAddresses[msg.sender] == true, "Not an admin");
        _;
    }

    // ToDo: add address to admin list:
    function addAdmin(address addr) public onlyOwner returns (bool) {
        adminAddresses[addr] = true;
        return true;
    }

    // ToDo: remove address from admin list:
    function removeAdmin(address addr) public onlyOwner returns (bool) {
        adminAddresses[addr] = false;
        return true;
    }

    // ToDo: create a payable buyTicket() function:
    function buyTicket(string memory name) public payable {
        require(msg.value > 0, "Insufficient Ether provided");
        Payments[msg.sender] = Payments[msg.sender] + msg.value;
        emit BuyTicket(msg.sender, msg.value, name);
    }

    // ToDo: create a sendToken() function:
    function sendToken(address addr, uint256 amount) public onlyOwner {
        nestedToken.transfer(addr, amount);
        Rewards[msg.sender] = Rewards[msg.sender] + amount;
        tokensAwarded = tokensAwarded + amount;
        if (Rewards[msg.sender] == 0) {
            customersAwarded += 1;
        }
        emit SendToken(addr, amount, msg.sender);
    }

    // Todo: create a sendToMultiple() function:
    function sendToMultiple(address[] memory arrOfAddresses, uint256 amount)
        public
        onlyAdmin
        returns (bool)
    {
        for (uint256 i = 0; i < arrOfAddresses.length; i++) {
            sendToken(arrOfAddresses[i], amount);
        }
        return true;
    }

    // ToDo: create a withdraw() function that lets the owner withdraw ETH
    function withdraw() public onlyOwner {
        (bool success, ) = msg.sender.call{value: address(this).balance}("");
        require(success, "Failed to withdraw money");
    }

    function getEthAmount() public view returns (uint256) {
        return address(this).balance;
    }

    // Add the `receive()` special function that receives eth and calls ()
    // Function to receive Ether. msg.data must be empty
    receive() external payable {
        buyTicket("anonymous");
    }
}
