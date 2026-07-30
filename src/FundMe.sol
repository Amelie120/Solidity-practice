//SPDX-License-Identifier: MIT

pragma solidity 0.8.18;

import {PriceConverter} from "./PriceConverter.sol";

//adding an error to check if its the same user throughout
error NotOwner();

contract FundMe {
    //using our library PriceConverter to get the latest priceFeed and do our conversions
    using PriceConverter for uint256;

    //creating a variable minimumUSD and making it a constant  as we are not going to change it 
    uint256 public constant MINIMUM_USD = 5e18;

    //making an array to track the funders
    address[] public funders;

    //creating a mapping to see how much each funder has
    mapping(address funders => uint256 amountFunded) public addressToAmountFunded;

    //creating owner to set it as default user throughout the contract
    address public immutable i_owner;

    //creating a constructor to set the msg.sender as the owner 
    constructor() {
        i_owner = msg.sender;
    }

    //making a function to send money 
    function fund() public payable {
        //adding a require to make sure the amount trying to send is at least greater than our minimumUSD
        require(msg.value.getConversionRate() >= MINIMUM_USD, "Didn't send enough ETH");
        //adding the new sender into our array funders
        funders.push(msg.sender);

        //matching the value funded to the sender 
        addressToAmountFunded[msg.sender] += msg.value;
    }

    //making a function to withdraw money
    function withdraw() public onlyOwner {
        //start, end, step amount
        //funder is the start index
        //we end it once the funderindex is less than the length of the array 
        //every single timee we do a loop we add 1 to fundersIndex
        for(uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++) {

            //matching funder to its index
            address funder = funders[funderIndex];

            //then reseting to 0 after because they are withdrawing money out
            addressToAmountFunded[funder] = 0;
        }
        //then reseting the array and withdrawing the funds
        funders = new address[](0);

        //call is the most appropriate way in solidity to withdraw
        (bool callSuccess, )=payable(i_owner).call{value: address(this).balance}("");
        require(callSuccess, "Call failed");

    }


    // creating a modifier to check that msg.sender is the owner
    modifier onlyOwner() {
        //require(msg.sender == i_owner, "Sender is not the owner"); is the same but uses more gas
        if(msg.sender != i_owner) {
            revert NotOwner();
            }
        //then continuing running through function 
        _;
    }

    //adding 2 special fujnctions in case someone sends us money by accident
    //so receive and fallback fujnctions
    receive() external payable {
        fund();
    }

    fallback() external payable {
        fund();
    }

}