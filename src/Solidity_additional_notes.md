## Additional Solidity notes and definitions

### Interface

An interface describes the functions another contract exposes without including their implementation. It tells Solidity which functions are available, their parameters, visibility, mutability, and return values.

```solidity
interface AggregatorV3Interface {
    function latestRoundData()
        external
        view
        returns (
            uint80 roundId,
            int256 answer,
            uint256 startedAt,
            uint256 updatedAt,
            uint80 answeredInRound
        );
}
```

A contract can interact with a deployed contract through that interface:

```solidity
AggregatorV3Interface priceFeed =
    AggregatorV3Interface(priceFeedAddress);
```

This tells Solidity to treat the contract at `priceFeedAddress` as a Chainlink price feed. The full implementation is not required; only the function definitions are needed.

---

### Library

A library contains reusable Solidity functions that other contracts can use.

```solidity
library PriceConverter {
    function getPrice() internal view returns (uint256) {
        // Read the current ETH/USD price
    }
}
```

A library function can be called directly:

```solidity
uint256 price = PriceConverter.getPrice();
```

It can also be attached to a type:

```solidity
using PriceConverter for uint256;
```

This allows:

```solidity
msg.value.getConversionRate();
```

Here, `msg.value` is passed as the first argument to `getConversionRate`.

Without `using for`, the same call could be written as:

```solidity
PriceConverter.getConversionRate(msg.value);
```

Libraries keep contracts organised and make logic reusable.

---

### Modifier

A modifier contains reusable logic that runs before or after a function.

```solidity
modifier onlyOwner() {
    require(msg.sender == i_owner, "Only the owner can call this");
    _;
}
```

The `_` represents the body of the function using the modifier.

```solidity
function withdraw() public onlyOwner {
    // Withdrawal logic
}
```

When `withdraw()` is called, the ownership check runs first. If it passes, Solidity reaches `_` and runs the function body. If it fails, the transaction reverts.

---

### Constant

A constant is a state variable whose value is fixed at compile time and can never change.

```solidity
uint256 public constant MINIMUM_USD = 5e18;
```

Constants are normally written in uppercase. They must be assigned when declared.

```solidity
uint256 public constant NUMBER = 10;
```

A constant is suitable when every deployment should use exactly the same value.

---

### Immutable

An immutable variable can only be assigned once, usually in the constructor.

```solidity
address public immutable i_owner;

constructor() {
    i_owner = msg.sender;
}
```

The value may be different for each deployment, but it cannot be changed afterwards.

```solidity
AggregatorV3Interface public immutable i_priceFeed;

constructor(address _priceFeedAddress) {
    i_priceFeed = AggregatorV3Interface(_priceFeedAddress);
}
```

The difference is:

- `constant`: fixed before deployment
- `immutable`: fixed during deployment

---

### Low-level interaction

A low-level interaction communicates using raw call data rather than a normal named Solidity function call.

The `.call` function is a low-level call:

```solidity
(bool success, ) = payable(msg.sender).call{
    value: moneyRemoved
}("");
```

This sends ETH to `msg.sender`. It returns `true` if successful and `false` if it fails.

```solidity
require(success, "Withdrawal failed");
```

In Remix, **Low level interactions** lets you manually send raw hexadecimal calldata or ETH directly to a contract address. It is useful for testing `receive()`, `fallback()`, manually encoded calls, or contracts without an ABI.

For normal beginner testing, use Remix's generated function buttons.

---

### Oracle

A blockchain cannot directly visit websites or call normal external APIs.

An oracle supplies off-chain information to smart contracts, such as:

- cryptocurrency prices
- weather information
- sports results
- interest rates
- proof of reserves

An oracle acts as a bridge between off-chain data and an on-chain contract.

Chainlink uses multiple data providers and oracle nodes so the result does not depend on one central source.

---

### Chainlink price feed

A Chainlink price feed is a deployed smart contract containing an aggregated market price.

For example, an ETH/USD feed stores the approximate current price of ETH in US dollars.

```solidity
AggregatorV3Interface priceFeed =
    AggregatorV3Interface(priceFeedAddress);
```

The price can be read using:

```solidity
(
    ,
    int256 answer,
    ,
    ,

) = priceFeed.latestRoundData();
```

The `answer` contains the latest published price.

If ETH is worth about `$3,000`, a feed using eight decimals may return:

```text
300000000000
```

Therefore:

```text
300000000000 / 10^8 = 3000
```

Chainlink nodes collect and aggregate external data, then publish the result to the on-chain feed contract. Your Solidity contract reads that stored on-chain value.

---

### Price converter

A price converter is not itself an oracle. It is Solidity logic that reads an oracle price and converts one value into another.

```solidity
function getPrice() internal view returns (uint256) {
    // Read ETH/USD price from the Chainlink feed
}
```

It can convert an ETH amount into its USD value:

```solidity
function getConversionRate(
    uint256 ethAmount
) internal view returns (uint256) {
    uint256 ethPrice = getPrice();

    uint256 ethAmountInUsd =
        (ethPrice * ethAmount) / 1e18;

    return ethAmountInUsd;
}
```

For example:

```text
ETH price = $3,000
ETH sent = 0.01 ETH
Converted value = about $30
```

The roles are:

- Chainlink oracle network obtains external price information
- Chainlink price feed stores the aggregated result on-chain
- `PriceConverter` reads the feed and performs the calculation
- `FundMe` uses the converted value to enforce a minimum contribution

---

### Event

An event creates a transaction log when something happens in a contract.

```solidity
event Funded(
    address indexed funder,
    uint256 amount
);
```

The event is recorded using `emit`:

```solidity
emit Funded(msg.sender, msg.value);
```

Events can record actions such as:

- deposits
- withdrawals
- token transfers
- ownership changes
- todo creation
- voting

External applications can listen for events and update their interfaces.

Event logs are not normal contract storage. The `indexed` keyword makes a value easier to search and filter.

```solidity
address indexed funder
```

---

### Struct

A struct is a custom data type that groups related values into one object.

```solidity
struct Todo {
    uint256 id;
    string description;
    bool completed;
}
```

A struct instance can be created like this:

```solidity
Todo memory newTodo = Todo({
    id: 0,
    description: "Learn Foundry",
    completed: false
});
```

It can also be added directly to an array:

```solidity
todos.push(
    Todo({
        id: todos.length,
        description: _description,
        completed: false
    })
);
```

Without a struct, separate arrays might be required for IDs, descriptions, and completion statuses. A struct keeps all information belonging to one item together.
