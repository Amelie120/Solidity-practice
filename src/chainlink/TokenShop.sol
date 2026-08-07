// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

// Chainlink interface that lets this contract read data
// from a Chainlink price feed contract
import {AggregatorV3Interface} from "@chainlink/contracts@1.3.0/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

// OpenZeppelin Ownable gives the contract an owner
// and lets us use the onlyOwner modifier
import {Ownable} from "@openzeppelin/contracts@5.2.0/access/Ownable.sol";

// Import our own ERC20 token contract
// so TokenShop can call functions like mint()
import {MyERC20} from "./MyERC20.sol";

contract TokenShop is Ownable {
    // This variable will point to the Chainlink ETH/USD price feed.
    // "immutable" means it is set once in the constructor
    // and cannot be changed afterwards.
    AggregatorV3Interface internal immutable i_priceFeed;

    // This variable stores the MyERC20 token contract
    // so TokenShop can interact with it.
    MyERC20 public immutable i_token;

    // Our ERC20 token uses 18 decimals.
    // 1 full token is represented as 1 * 10^18.
    uint256 public constant TOKEN_DECIMALS = 18;

    // We decide that 1 CLF token costs $2.
    //
    // Solidity does not use normal floating-point numbers,
    // so we represent $2 using 18 decimals:
    //
    // 2 * 10^18
    uint256 public constant TOKEN_USD_PRICE =
        2 * 10 ** TOKEN_DECIMALS;

    // Event emitted when the owner withdraws ETH
    // from the TokenShop contract.
    event BalanceWithdrawn();

    // Custom error used when someone sends 0 ETH.
    error TokenShop__ZeroETHSent();

    // Custom error used if withdrawing ETH fails.
    error TokenShop__CouldNotWithdraw();

    // The constructor runs once when TokenShop is deployed.
    //
    // tokenAddress = address of our deployed MyERC20 contract.
    //
    // Ownable(msg.sender) makes whoever deploys TokenShop
    // the owner of TokenShop.
    constructor(address tokenAddress) Ownable(msg.sender) {
        // Convert the tokenAddress into a MyERC20 contract reference.
        //
        // This connects TokenShop to our ERC20 contract
        // so we can later call:
        //
        // i_token.mint(...)
        i_token = MyERC20(tokenAddress);

        /*
         * Network: Sepolia
         * Price Feed: ETH / USD
         *
         * This is the Chainlink ETH/USD
         * price feed address on Sepolia.
         */
        i_priceFeed = AggregatorV3Interface(
            0x694AA1769357215DE4FAC081bf1f309aDC325306
        );
    }

    /**
     * Gets the latest ETH/USD price from Chainlink.
     */
    function getChainlinkDataFeedLatestAnswer()
        public
        view
        returns (int)
    {
        // latestRoundData() returns 5 values:
        //
        // roundId
        // price
        // startedAt
        // updatedAt
        // answeredInRound
        //
        // We only care about the price here,
        // so we ignore the other values.
        (
            /* uint80 roundID */,
            int price,
            /* uint256 startedAt */,
            /* uint256 updatedAt */,
            /* uint80 answeredInRound */
        ) = i_priceFeed.latestRoundData();

        // Return the latest ETH/USD price.
        //
        // The ETH/USD Chainlink feed uses 8 decimals.
        //
        // Example:
        //
        // 250000000000
        //
        // represents:
        //
        // $2500.00000000
        return price;
    }

    /**
     * Calculates how many CLF tokens should be minted
     * for a particular amount of ETH.
     */
    function amountToMint(uint256 amountInETH)
        public
        view
        returns (uint256)
    {
        // Get the ETH/USD price from Chainlink.
        //
        // Chainlink returns the price with 8 decimals,
        // but ETH and our ERC20 token use 18 decimals.
        //
        // Multiplying by 10^10 converts:
        //
        // 8 decimals -> 18 decimals
        uint256 ethUsd =
            uint256(getChainlinkDataFeedLatestAnswer()) * 10 ** 10;

        // Convert the ETH sent into its USD value.
        //
        // amountInETH is in wei,
        // which uses 18 decimals.
        //
        // Conceptually:
        //
        // ETH sent × ETH/USD price = USD value
        //
        // We divide by 10^18 so the decimals remain correct.
        uint256 ethAmountInUSD =
            amountInETH * ethUsd / 10 ** 18;

        // Work out how many CLF tokens the user should receive.
        //
        // Each CLF token costs $2.
        //
        // Conceptually:
        //
        // token amount = USD value / token price
        //
        // We multiply by 10^18 so the returned token amount
        // uses ERC20's 18 decimal format.
        return
            (ethAmountInUSD * 10 ** TOKEN_DECIMALS)
            / TOKEN_USD_PRICE;
    }

    /**
     * The receive function automatically runs
     * when someone sends ETH directly to TokenShop.
     */
    receive() external payable {
        // msg.value = amount of ETH sent with the transaction.
        //
        // If the user sends 0 ETH, cancel the transaction.
        if (msg.value == 0) {
            revert TokenShop__ZeroETHSent();
        }

        // Calculate how many CLF tokens the user should receive,
        // then tell MyERC20 to mint those tokens.
        //
        // msg.sender = the person who sent the ETH.
        //
        // IMPORTANT:
        // TokenShop must have MINTER_ROLE in MyERC20,
        // otherwise this call will revert.
        i_token.mint(
            msg.sender,
            amountToMint(msg.value)
        );
    }

    /**
     * Allows the TokenShop owner to withdraw
     * all ETH collected from token purchases.
     */
    function withdraw() external onlyOwner {
        // address(this) = this TokenShop contract.
        //
        // address(this).balance = all ETH currently held
        // inside TokenShop.
        //
        // owner() = owner address provided by Ownable.
        //
        // .call sends all the ETH to the owner.
        (bool success, ) =
            payable(owner()).call{
                value: address(this).balance
            }("");

        // If sending the ETH failed,
        // revert the whole transaction.
        if (!success) {
            revert TokenShop__CouldNotWithdraw();
        }

        // Record that the withdrawal happened.
        emit BalanceWithdrawn();
    }
}