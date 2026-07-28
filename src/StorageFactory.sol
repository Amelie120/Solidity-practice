// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

import {SimpleStorage} from "./SimpleStorage.sol";

//We are going to create multiple separate SimpleStorage contracts
//and store references to those contracts in an array using an index
contract StorageFactory {
    //storing SimpleStorage contract references in an array
    SimpleStorage[] public listOfSimpleStorageContracts;

    //creating a function that creates a new SimpleStorage contract
    function createSimpleStorageContract() public {
        //creating a new instance of SimpleStorage
        SimpleStorage newSimpleStorageContract = new SimpleStorage();

        //next we add  the new contract reference to the array
        listOfSimpleStorageContracts.push(newSimpleStorageContract);
    }

    //creating a function that calls store() on a selected simpleStorage contract
    function sfStore(uint256 _simpleStorageIndex, uint256 _newSimpleStorageNumber) public {
        //Selecting one contract from the array
        SimpleStorage mySimpleStorage = listOfSimpleStorageContracts[_simpleStorageIndex];

        //calling store() on the selected SimpleStorage contract
        mySimpleStorage.store(_newSimpleStorageNumber);

        //For example:
        //sfStore(0, 25)
        //selects the contract number 0 and calls its store(25) function.
    }

    //Creating a function to retrieve the favourite number from a selected SimpleStorage contract
    function sfGet(uint256 _simpleStorageIndex) public view returns (uint256) {
        //selecting one contract from the array
        SimpleStorage mySimpleStorage = listOfSimpleStorageContracts[_simpleStorageIndex];

        //calling retrieve() on the selected contract and returning its stored favourite number
        return mySimpleStorage.retrieve();
    }
}