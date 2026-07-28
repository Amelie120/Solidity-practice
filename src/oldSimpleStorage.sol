//SPDX-License-Identifier: MIT
pragma solidity  0.8.18;

contract SimpleStorage {
    //creating the favouriteNumber state variable
    uint256 public favouriteNumber;

    //creating a map to connect the names of the people to their favouriteNumber
    mapping(string => uint256) public nameToFavouriteNumber;

    //creating a function to store our favourite number 
    //this receives a number and permanentely saves it int he contract's state variable
    //store also updates the number at any time
    function store(uint256 _favouriteNumber) public  {
        favouriteNumber = _favouriteNumber;
    }

    //creating a function to increase the stored number by six
    function addSix() public {
        favouriteNumber = favouriteNumber + 6;
    }

    //creating a function to retrieve our  favourite number
    function retrieve() public view returns (uint256) {
        return favouriteNumber;
    }

    //defining a person struct with a name and favourite number
    //struct is only a blueprint basically 
    struct Person {
        string name;
        uint256 favouriteNumber;
    }

    //storing people in an array
    Person[] public personList;

    //creating a function to add people to our personList array
    function addToPeopleList(string memory _name, uint256 _favouriteNumber) public {
        personList.push(Person({name: _name, favouriteNumber: _favouriteNumber}));
        nameToFavouriteNumber[_name] = _favouriteNumber;
    }
}