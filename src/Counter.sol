//SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

contract Counter {
    //creating a Counter
    uint256 public counter; //the counter is already set to start at 0 by default

    //creating a funciton to increase our counter by 1
    function addOne() public {
        counter += 1;
    }

    //creating a function to decrease counter by 1
    function MinusOne() public {
        //because counter is a uint256, when we subtract zero the transaction is going to revert
        //so we need to check that the transaction is above zero first
        require(counter > 0, "Counter cannot be below zer0");
        //if not we stop the stransaction
        counter -= 1;
    }

    //creating a function to reset it to 0
    //the caller doesnt have a number because reset is always going to set the counter to zero for us
    function reset() public {
        counter = 0;
    }

    //basic function to return our counter value
    //technically counter already has its own getter because its public but incase
    function getCounter() public view returns(uint256) {
        return counter;
    }

}