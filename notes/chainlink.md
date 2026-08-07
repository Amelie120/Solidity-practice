# Chainlink Fundamentals Notes

My notes from the Cyfrin Updraft Chainlink Fundamentals course.

So far I have covered:

- Solidity / smart contract refresher
- ERC-20 tokens
- OpenZeppelin
- Access control
- Oracles
- Chainlink
- Data Feeds / Price Feeds
- Aggregators
- TokenShop project

---

# What is Chainlink?

Chainlink is basically a **decentralized oracle network**.

The main problem it solves is that smart contracts cannot just go onto the internet and get information themselves.

For example, a Solidity smart contract cannot just ask Google or CoinMarketCap:

> "What is the price of ETH right now?"

Blockchains are isolated from the outside world, so they need another system to bring that information on-chain.

That is where Chainlink comes in.

A simple way I remember it is:

```text
Outside world
     ↓
 Chainlink
     ↓
Blockchain
     ↓
Smart Contract
```

For the TokenShop project, Chainlink gives our smart contract the current **ETH/USD price**.

---

# On-chain vs Off-chain

## On-chain

On-chain means something exists or happens directly on the blockchain.

Examples:

- Smart contracts
- Transactions
- Wallet balances
- ERC-20 balances
- Contract state

## Off-chain

Off-chain means something exists outside the blockchain.

Examples:

- APIs
- Websites
- Exchange prices
- Weather information
- Databases
- Sports results

So Chainlink is basically helping connect the **off-chain world** with the **on-chain world**.

---

# The Oracle Problem

Smart contracts need to be **deterministic**.

This means that if every node gets the same input, they all need to get the same output.

Imagine every Ethereum node tried to call an API itself:

```text
Node 1 → ETH = $3000
Node 2 → ETH = $3001
Node 3 → API fails
```

Now the nodes would not agree.

That would be a problem because blockchain consensus depends on everyone reaching the same result.

So smart contracts cannot just directly request normal internet data.

This is known as the **Oracle Problem**.

---

# What is an Oracle?

An oracle is basically a way of getting information between a blockchain and something outside the blockchain.

For example:

```text
ETH price from exchanges
        ↓
      Oracle
        ↓
     Ethereum
        ↓
 Smart Contract
```

Important thing:

The oracle is not necessarily the original source of the information.

For example, Chainlink does not decide what ETH is worth.

Instead, it gets information from external sources and makes that information available to smart contracts.

---

# Types of Oracles

The course talked about four main types.

## Inbound Oracle

Inbound means:

```text
Outside world → Blockchain
```

It brings information onto the blockchain.

Examples:

- ETH/USD price
- Weather
- Sports results
- Stock prices

The Chainlink ETH/USD Price Feed we used is an example of this.

---

## Outbound Oracle

Outbound is the opposite:

```text
Blockchain → Outside world
```

Something that happens on-chain can cause something to happen in an external system.

Easy way to remember:

```text
Inbound  = data coming INTO blockchain

Outbound = data going OUT from blockchain
```

---

## Consensus Oracle

A consensus oracle uses multiple sources rather than trusting only one.

Instead of:

```text
One source → answer
```

we might have:

```text
Source A ─┐
Source B ─┤
Source C ─┼→ Final result
Source D ─┘
```

This is better because if one source is wrong or gets manipulated, the whole result does not necessarily depend on it.

---

## Cross-Chain Oracle

Cross-chain means communication between different blockchains.

For example:

```text
Ethereum
    ↓
Cross-chain system
    ↓
Arbitrum
```

Different blockchains normally cannot just talk to each other directly.

Chainlink has **CCIP** for cross-chain communication, which is covered later in the course.

---

# Centralized vs Decentralized Oracles

One thing I understood from this section is that using an oracle does not automatically make something decentralized.

## Centralized Oracle

Imagine a smart contract gets its ETH price from one company.

```text
Smart Contract
     ↓
One Oracle
     ↓
One Source
```

Now that one oracle becomes a single point of failure.

If it:

- gets hacked
- goes offline
- gives the wrong information
- manipulates the information

the smart contract could make the wrong decision.

That is not ideal for a decentralized system.

---

## Decentralized Oracle

Instead, Chainlink can use multiple independent nodes and multiple data sources.

```text
Different data sources
       ↓
Different oracle nodes
       ↓
Aggregation
       ↓
Final result
```

So we are reducing the amount of trust we need to place in one individual party.

---

# DON - Decentralized Oracle Network

DON stands for:

**Decentralized Oracle Network**

Chainlink uses multiple independent oracle nodes.

Very simplified:

```text
Data Sources
    ↓
Chainlink Nodes
    ↓
Aggregation / Consensus
    ↓
Result
    ↓
Blockchain
```

This helps with things like:

- Trust
- Accuracy
- Reliability

If one source or node has a problem, we do not want the whole system to depend on it.

---

# Chainlink Services

Chainlink does more than just prices.

These are the main services from the course.

I have not covered all of these properly yet, so these are just basic definitions for now.

---

## Data Feeds

Data Feeds provide external information to smart contracts.

Examples include:

- Asset prices
- Reserve information
- Rates
- L2 status

The one I have actually used so far is a **Price Feed**.

---

## Price Feeds

A Price Feed is a type of Data Feed specifically for market prices.

Examples:

```text
ETH/USD
BTC/USD
LINK/USD
```

These are useful in DeFi because protocols need to know how much assets are worth.

---

## Chainlink Automation

Automation lets smart contract functions be triggered when certain conditions are met.

Normally, smart contracts cannot just run themselves.

Someone has to send a transaction.

Chainlink Automation can monitor something and trigger the contract when needed.

---

## Chainlink CCIP

CCIP stands for:

**Cross-Chain Interoperability Protocol**

It is used for sending tokens/messages between different blockchains.

```text
Blockchain A
     ↕
    CCIP
     ↕
Blockchain B
```

---

## Chainlink Functions

Chainlink Functions lets smart contracts use external APIs and off-chain computation.

So instead of doing everything directly inside Solidity, some work can happen outside the blockchain and the result can then be brought back on-chain.

---

## Chainlink VRF

VRF stands for:

**Verifiable Random Function**

It provides random numbers that can be verified.

Randomness is actually difficult on a blockchain because blockchains are deterministic.

This can be useful for:

- Games
- Lotteries
- Random NFT traits
- Random selection

---

## Data Streams

Data Streams are for faster / high-frequency market data.

This is more useful for applications that need very quick price updates.

---

## Proof of Reserve

Proof of Reserve can be used to check whether an asset actually has the reserves/backing it claims to have.

---

# LINK Token

LINK is the token used in the Chainlink ecosystem.

It can be used for things such as paying node operators and helping with the economic security of Chainlink services.

Important:

```text
ETH/USD Price Feed = data

LINK = token used in Chainlink ecosystem
```

They are not the same thing.

---

# Solidity Refresher

Before getting into Chainlink, the course went over some Solidity basics again.

Things covered included:

- State variables
- Functions
- Constructors
- `msg.sender`
- `msg.value`
- `payable`
- Events
- Errors
- Inheritance
- Imports
- Interfaces
- Remix
- Contract deployment
- Contract interaction

---

# Inheritance

Inheritance means one smart contract can reuse functionality from another contract.

For example:

```text
OpenZeppelin ERC20
        ↓
     MyERC20
```

Instead of writing the entire ERC-20 standard ourselves, we inherit OpenZeppelin's implementation.

We did the same thing with TokenShop and `Ownable`.

---

# OpenZeppelin

OpenZeppelin provides smart contract implementations that developers can reuse.

For this project we used:

- `ERC20`
- `AccessControl`
- `Ownable`

This means we did not need to write these systems completely from scratch.

---

# ERC-20

ERC-20 is basically a **standard/set of rules for fungible tokens on Ethereum**.

It gives tokens a common interface.

This is useful because wallets, exchanges and smart contracts already know how ERC-20 tokens behave.

For example, ERC-20 tokens generally have things like:

- `balanceOf`
- `transfer`
- `approve`
- `allowance`
- `transferFrom`
- `totalSupply`

So if I create my own ERC-20 token, MetaMask and other applications already know how to interact with it.

---

# Fungible Tokens

Fungible means that each token is interchangeable.

```text
1 CLF = 1 CLF
```

Like money:

```text
£1 = £1
```

This is different from an NFT where each individual token can be unique.

---

# ERC-20 vs ERC-721

## ERC-20

Used for fungible tokens.

```text
1 token = another token
```

## ERC-721

Used for NFTs.

Each token can have its own identity.

```text
NFT #1 ≠ NFT #2
```

---

# ERC-20 Functions I Used

## balanceOf

Checks how many tokens an address owns.

---

## transfer

Sends your tokens to another address.

---

## approve

Lets another address or smart contract spend some of your tokens.

Important:

`approve` does not actually send the tokens.

It only gives permission.

---

## allowance

Checks how much a spender is currently allowed to spend.

For example:

```text
Owner = me
Spender = another contract
Allowance = 10 CLF
```

The contract can spend up to 10 CLF from my account.

---

## transferFrom

Allows an approved spender to transfer tokens from someone's account.

---

## totalSupply

Shows how many tokens currently exist.

---

# Token Decimals

Our CLF token uses **18 decimals**.

Solidity works with integers, so:

```text
1 CLF
=
1,000,000,000,000,000,000
=
10^18
```

So if I want 100 CLF:

```text
100 × 10^18
=
100000000000000000000
```

This looked confusing at first but it is basically just how ERC-20 represents fractional tokens without using floating point numbers.

---

# Minting

Minting means **creating new tokens**.

When tokens are minted:

```text
Total supply increases
        +
User balance increases
```

Our token started with no supply.

Then we created a mint function so authorised accounts could create CLF tokens.

---

# AccessControl

We used OpenZeppelin's `AccessControl` because we do not want every person to be able to mint unlimited tokens.

We created:

```text
MINTER_ROLE
```

Only an address with this role can mint.

```text
Has MINTER_ROLE → mint ✓

No MINTER_ROLE → mint fails ✗
```

---

# DEFAULT_ADMIN_ROLE

The deployer of MyERC20 gets:

```text
DEFAULT_ADMIN_ROLE
MINTER_ROLE
```

The admin role can manage other roles.

For example, the admin can give `MINTER_ROLE` to another address.

This became important when we created TokenShop.

---

# MyERC20

`MyERC20` is the token contract we created.

It represents our:

```text
CLF token
```

It is responsible for things like:

- Balances
- Transfers
- Supply
- Approvals
- Minting
- Permissions

So I think of it as the actual **token/accounting contract**.

---

# TokenShop

After creating the ERC-20 token, we created another smart contract called `TokenShop`.

TokenShop lets someone buy our CLF token using ETH.

The idea is:

```text
User sends ETH
      ↓
TokenShop checks ETH price
      ↓
Calculates USD value
      ↓
Calculates how many CLF tokens that buys
      ↓
MyERC20 mints CLF
      ↓
User receives CLF
```

We decided:

```text
1 CLF = $2
```

So TokenShop needs to know how much the ETH the user sends is worth in USD.

That is why Chainlink is needed.

---

# Why MyERC20 and TokenShop are Separate

This confused me at first.

They have different jobs.

## MyERC20

Deals with the actual token.

```text
balances
transfers
minting
supply
```

## TokenShop

Deals with buying the token.

```text
receive ETH
get ETH/USD price
calculate amount
ask MyERC20 to mint
```

A useful analogy:

```text
MyERC20 = token factory / accounting system

TokenShop = vending machine

Chainlink = tells the vending machine the current ETH price
```

---

# Connecting TokenShop to MyERC20

When TokenShop is deployed, we give it the address of the MyERC20 contract.

Basically we are telling TokenShop:

> "This is the token contract you need to interact with."

TokenShop can then call MyERC20's functions.

This was my first clear example of **contract-to-contract interaction**.

```text
TokenShop
    ↓
MyERC20
```

---

# Why TokenShop Needs MINTER_ROLE

This was probably the main thing I needed to understand.

When a user sends ETH to TokenShop, **the user is not directly calling `mint()`**.

Instead:

```text
User
 ↓
TokenShop
 ↓
MyERC20.mint()
```

So from MyERC20's point of view, the address calling `mint()` is:

```text
TokenShop
```

Therefore TokenShop needs:

```text
MINTER_ROLE
```

Without it:

```text
TokenShop → mint
             ↓
     No MINTER_ROLE
             ↓
          REVERT
```

So after deploying TokenShop, we used `grantRole` on MyERC20 to give the TokenShop contract permission to mint.

Then we used `hasRole` to check that it worked.

---

# Chainlink Data Feeds

Data Feeds make external data available on-chain.

The important one for our project is:

```text
ETH/USD
```

TokenShop needs to know:

> "How many dollars is the ETH the user sent worth?"

Chainlink provides that information.

---

# Consumer, Proxy and Aggregator

These are three terms I need to remember.

```text
Consumer
   ↓
 Proxy
   ↓
Aggregator
```

---

## Consumer

The **consumer** is the smart contract using the Chainlink information.

In our project:

```text
TokenShop = consumer
```

---

## Aggregator

The aggregator holds the result produced from Chainlink oracle data.

Very simplified:

```text
Multiple oracle nodes
      ↓
   Aggregation
      ↓
ETH/USD result
```

The final value is stored on-chain so contracts can use it.

---

## Proxy

The consumer usually interacts with a **Proxy** rather than directly depending on a specific aggregator.

Why?

Because the underlying aggregator might be upgraded.

For example:

```text
TokenShop
    ↓
 Proxy
    ↓
Aggregator V1
```

Later:

```text
TokenShop
    ↓
 Proxy
    ↓
Aggregator V2
```

TokenShop can still use the same proxy address.

So I remember:

```text
Consumer → Proxy → Aggregator
```

---

# AggregatorV3Interface

We used:

```text
AggregatorV3Interface
```

This is an interface that tells our Solidity contract which functions the Chainlink Price Feed supports.

It is basically like saying:

> "I know the contract at this address follows this interface, so I can call these functions."

Some useful functions are:

- `latestRoundData()`
- `decimals()`
- `description()`
- `version()`

The interface itself does not generate the price.

It just gives us a way to communicate with the Price Feed contract.

---

# latestRoundData()

We used `latestRoundData()` to get the latest ETH/USD price.

It returns several pieces of information, including:

- Round ID
- Price
- When the round started
- When the price was updated
- Answered-in-round information

For TokenShop we mostly cared about:

```text
price
```

---

# Price Feed Decimals

The ETH/USD feed we used has **8 decimals**.

So if Chainlink returns something like:

```text
191796000000
```

that means:

```text
191796000000 / 10^8
=
1917.96
```

So ETH would be roughly:

```text
$1,917.96
```

This is important because Solidity does not use normal decimal numbers.

---

# Why We Convert 8 Decimals to 18

Chainlink ETH/USD:

```text
8 decimals
```

ETH and CLF:

```text
18 decimals
```

So in TokenShop we convert the Chainlink value to 18 decimals.

The difference is:

```text
18 - 8 = 10
```

So we multiply by:

```text
10^10
```

Now the values use compatible decimal precision for our calculations.

---

# TokenShop Price Calculation

We decided:

```text
1 CLF = $2
```

Imagine:

```text
1 ETH = $2,000
```

A user sends:

```text
0.01 ETH
```

That ETH is worth:

```text
0.01 × 2000 = $20
```

Then:

```text
$20 / $2 per CLF = 10 CLF
```

So:

```text
0.01 ETH
   ↓
$20
   ↓
10 CLF
```

---

# amountToMint

`amountToMint` basically answers:

> "If someone sends this amount of ETH, how many CLF tokens should they get?"

Flow:

```text
ETH amount
    ↓
Get ETH/USD price
    ↓
Calculate USD value
    ↓
Divide by CLF price
    ↓
Amount of CLF
```

---

# receive()

The `receive` function automatically runs when someone sends ETH directly to the TokenShop contract.

So instead of calling something like:

```text
buyTokens()
```

the user can simply send ETH to the contract.

Then:

```text
ETH arrives
    ↓
receive()
    ↓
calculate amount
    ↓
mint CLF
```

---

# msg.value

`msg.value` is the amount of ETH sent with the transaction.

So inside TokenShop:

```text
msg.value = ETH paid by the user
```

---

# msg.sender

`msg.sender` is whoever called the current contract/function.

Inside TokenShop:

```text
msg.sender = user buying CLF
```

So CLF gets minted to that user.

But when TokenShop calls MyERC20:

```text
MyERC20 sees:

msg.sender = TokenShop
```

This explains again why TokenShop needs `MINTER_ROLE`.

---

# Ownable

TokenShop also inherits OpenZeppelin's `Ownable`.

This gives the contract an owner.

The deployer becomes the owner.

We can then restrict functions using:

```text
onlyOwner
```

For example, only the owner should be able to withdraw the ETH that TokenShop has collected.

---

# Withdrawing ETH

When users buy CLF:

```text
User
 ↓ ETH
TokenShop
```

The ETH stays inside TokenShop.

The owner can later withdraw it.

```text
TokenShop
    ↓
withdraw
    ↓
Owner
```

Only the owner can call this function.

---

# Events

Events are a way for smart contracts to record important things in blockchain logs.

For example, TokenShop emits an event after ETH is successfully withdrawn.

External applications can listen for these events.

---

# Custom Errors

We also used custom errors.

For example:

- User sends 0 ETH
- ETH withdrawal fails

If one of these things happens, the transaction reverts.

---

# Full TokenShop Flow

This is the main thing I want to remember from this section:

```text
User sends ETH
      ↓
TokenShop
      ↓
Gets ETH/USD price from Chainlink
      ↓
Calculates USD value of ETH
      ↓
Calculates how many CLF tokens the user should get
      ↓
TokenShop calls MyERC20.mint()
      ↓
MyERC20 checks TokenShop has MINTER_ROLE
      ↓
CLF gets minted
      ↓
User receives CLF
```

And Chainlink is working in the background like:

```text
External price sources
        ↓
Chainlink Oracle Network
        ↓
Aggregator
        ↓
Proxy / Price Feed
        ↓
TokenShop
```

---

# Things I Keep Mixing Up

## ERC-20 vs MyERC20

```text
ERC-20
=
the standard / rules

MyERC20
=
my actual CLF token contract
```

---

## MyERC20 vs TokenShop

```text
MyERC20
=
creates/manages the token

TokenShop
=
sells the token
```

---

## Data Feed vs Price Feed

```text
Data Feed
=
general category of external data

Price Feed
=
a Data Feed specifically for prices
```

---

## Consumer vs Aggregator

```text
Consumer
=
uses the data

Aggregator
=
stores the aggregated oracle result
```

Our consumer is:

```text
TokenShop
```

---

## Proxy vs Aggregator

```text
Consumer → Proxy → Aggregator
```

The proxy gives consumers a stable place to access the feed even if the underlying aggregator changes.

---

## approve vs MINTER_ROLE

These are completely different.

### approve

Gives someone permission to **spend tokens that already exist**.

### MINTER_ROLE

Gives someone permission to **create new tokens**.

```text
approve
=
spend permission

MINTER_ROLE
=
mint permission
```

---

## Mint vs Transfer

Mint:

```text
creates new tokens
totalSupply increases
```

Transfer:

```text
moves existing tokens
totalSupply does not change
```

---

# Main Things I Learned

### ERC-20

A common standard for fungible tokens.

### Oracle Problem

Smart contracts cannot safely access normal external information by themselves.

### Oracle

Connects blockchain applications with external data/systems.

### Chainlink

A decentralized oracle network that provides external data and other services to smart contracts.

### DON

Decentralized Oracle Network.

### Inbound Oracle

```text
Outside → Blockchain
```

### Outbound Oracle

```text
Blockchain → Outside
```

### Consensus Oracle

Uses multiple sources/nodes to get a more reliable result.

### Cross-Chain Oracle

Helps different blockchains communicate.

### Price Feed

Provides prices such as ETH/USD.

### Consumer

The smart contract using the data.

### Aggregator

Stores the aggregated oracle result.

### Proxy

Stable access point between consumers and the aggregator.

### AggregatorV3Interface

Lets our Solidity contract interact with the Chainlink Price Feed.

### MyERC20

Our CLF ERC-20 token.

### TokenShop

Lets users buy CLF with ETH.

### MINTER_ROLE

Allows TokenShop to create CLF through MyERC20.

---

# My Mental Model

The simplest way for me to remember the whole thing:

```text
ERC-20
=
rules for creating a fungible token

MyERC20
=
our CLF token

AccessControl
=
controls who can mint it

Chainlink
=
gets information from outside the blockchain

ETH/USD Price Feed
=
tells us what ETH is worth

TokenShop
=
uses that price to sell CLF

MINTER_ROLE
=
allows TokenShop to mint CLF
```

And the full idea:

```text
Real-world ETH price
        ↓
     Chainlink
        ↓
     TokenShop
        ↓
      MyERC20
        ↓
     User gets CLF
```

---

# Short Summary

Chainlink solves the problem of smart contracts being unable to directly access external information.

In our TokenShop project, Chainlink gives us the current ETH/USD price. TokenShop uses that price to calculate how many CLF tokens someone's ETH is worth, then calls our MyERC20 contract to mint those tokens to the buyer.

The project helped me understand how **ERC-20 tokens, access control, contract-to-contract calls and Chainlink Price Feeds can all work together**.