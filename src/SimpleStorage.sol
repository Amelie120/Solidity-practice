//SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

contract SimpleStorage {
    //favouriteNumber gets initialized to 0 if no value is given
    uint256  public myfavouriteNumber; //0

    //array
    //uint256[] listofFavouriteNumbers;

    //because we want to specifically know what number belongs to what person we can create a person class
    struct Person{
        //person class has their favourite number and a name
        uint256 favouriteNumber;
        string name;
    }

    //dynamic array - because the size of the array can grow and shrink
    //Person[3] - static array as we set a limit of only 3 things inside our list
    Person[] public listOfPeople; //[] empty list rn
    //adding a variable in our persons class
    //Person public Lily = Person(7, "Lily");

    //making a dictionary - so a mapping essentially
    //every name links to a number so chelsea - > 3 
    mapping(string => uint256) public nameToFavouriteNumber;

    //function to store a uint in our smart contract
    function store(uint256 _favouriteNumber) public virtual {
        myfavouriteNumber = _favouriteNumber;
    }

    //function to return favouriteNumber with returns() 
    function retrieve() public view returns(uint256) {
        return myfavouriteNumber;
    }

    //creating a function to add people to our listOfpeople faster
    //solidity has a function already to push variables into arrays
    function addPerson(string memory _name, uint256 _favouriteNumber) public {
        listOfPeople.push((Person(_favouriteNumber, _name)));
        nameToFavouriteNumber[_name] = _favouriteNumber;
    }
}


contract SimpleStorage2 {

}