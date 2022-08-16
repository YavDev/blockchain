// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;


contract Ownable {
    address public owner;

    modifier onlyOwner() {
        require(owner == msg.sender, "Only the Owner of the Store can add new Products an change the Quantities");
        _;
    }

    constructor() {
        owner = msg.sender;
    }
}