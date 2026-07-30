//SPDX-License-Identifier: MIT

pragma solidity 0.8.18;

//eth contract

contract PayablePiggyBank {
    //creating owner variable
    address public immutable i_owner;

    //mapping each address to the amount funded
    mapping(address funder => uint256 amountDeposited) public balances;


    //accepting eth  
    function deposit() public payable {
        require(msg.value > 0, "Deposit must be greater than zero");
        //adding the ETH sent in this transaction to the sender's recorded balance
        balances[msg.sender] += msg.value;
    }

    //function to return the caller's deposited balance
    function getMyBalance() public view returns (uint256) {
        return balances[msg.sender];
    }

    constructor() {
        i_owner = msg.sender;
    }

    //creating a balance getter that returns all the ETH currently held by the contract
    function getContractBalance() public view returns (uint256) {
        return address(this).balance;
    }

    //creating a withdraw function 
    function withdraw(uint256 moneyRemoved) public {
        //the caller can only withdraw an amount less than or equal to their own recorded deposit.
        require(balances[msg.sender] >= moneyRemoved, "Insufficient balance");

        //updating the user's recorded balance first
        balances[msg.sender] -= moneyRemoved;

        //sending the requested ETH amount to the caller
        (bool callSuccess, ) = payable(msg.sender).call{value: moneyRemoved}("");

        require(callSuccess, "withdrawal failed");

    }

}