//SPDX-License-Identifier: MIT

pragma solidity 0.8.18;

//using an interrface to talk to chainlin for the price feed 
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

//creating a library to use in the FundMe contract to convert prices 
library PriceConverter {
    //function to get the price of etherum in terms of USD as a uing256
    function getPrice() internal view returns(uing256) {

        //address is 0x694AA1769357215DE4FAC081bf1f309aDC325306
        //ABI done
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        
        //to return multiple data types we do '()'
        (, int256 answer, , , ) = priceFeed.latesRoundData();

        //Price of eth in terms of USD
        //its going to be like 2000.0000000 from 8 decimals to 18 decimals
        return uint256(answer) *1e10;
    }

    //creating a function to get the conversion rate
    function getConversionRate(uint256 ethAmount) internal view returns(uint256) {
        //msg.value.getConversionRate() u could do throughout

        //doing the conversion exactly
        uint256 ethPrice = getPrice();

        //dividing by 18 because botj of them have 18 decimal places
        //2000_000000000000000000 * 1_000000000000000000 / 1e18 
        uint256 ethAmountInUsd = (ethPrice * ethAmount ) / 1e18;
        return ethAmountInUsd;
    }
    
    //function to get the version 
    function getVersion() internal view returns(uint256) {
        return AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306).version();
    }

}