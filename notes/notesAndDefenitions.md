## Solidity notes and definitions

* State variable

A state variable is declared inside a contract but outside its functions. Its value is stored permanently in the contract's blockchain storage, and it remains available between function calls. For example:

```solidity
uint256 public favouriteNumber;
```

* Struct

A struct is a custom data type that groups multiple related values into one object. For example, in `SimpleStorage.sol`, each `Person` contains a name and a favourite number:

```solidity
struct Person {
    string name;
    uint256 favouriteNumber;
}
```

* Dynamic array

A dynamic array is a list whose size can grow or shrink while the contract is being used. In `SimpleStorage.sol`, `personList` is an array that can store multiple `Person` structs.

```solidity
Person[] public personList;
```

* Mapping

A mapping stores key-to-value relationships and allows a value to be found using its key, similar to a dictionary. A person's name is used to find their favourite number:

```solidity
mapping(string => uint256) public nameToFavouriteNumber;
```

Each name links to a favourite number:

```solidity
nameToFavouriteNumber["Amelie"] = 7;
```

* Public function

A public function can be called from outside the contract, from inside the contract, and by other contracts.

```solidity
function store(uint256 _favouriteNumber) public {
    favouriteNumber = _favouriteNumber;
}
```

The `store` function allows someone to update the stored favourite number.

* View function

A view function can read blockchain state but cannot modify it.

```solidity
function retrieve() public view returns (uint256) {
    return favouriteNumber;
}
```

The function reads and returns `favouriteNumber`, but it does not change it.

* Memory

`memory` is a temporary data location that exists only while a function is running. It is commonly used for reference types such as strings, arrays, structs, and bytes.

```solidity
function addToPeopleList(
    string memory _name,
    uint256 _favouriteNumber
) public {

}
```

The `_name` string only exists temporarily during the function call.

Value types such as `uint256`, `bool`, and `address` do not normally need an explicit data location.

* Push

`push` adds a new element to the end of a dynamic storage array.

```solidity
personList.push(
    Person({
        name: _name,
        favouriteNumber: _favouriteNumber
    })
);
```

This creates a new `Person` struct and adds it to `personList`.

* Function parameters

A function parameter is an input value provided by whoever calls the function.

```solidity
function store(uint256 _favouriteNumber) public {
    favouriteNumber = _favouriteNumber;
}
```

Here, `favouriteNumber` is the permanent state variable.

`_favouriteNumber` is the temporary function parameter.

When someone calls:

```solidity
store(10);
```

During the function call, `_favouriteNumber` holds the value `10`.

The function then stores that value permanently:

```solidity
favouriteNumber = _favouriteNumber;
```

After the function finishes, `_favouriteNumber` disappears, but the state variable keeps the value `10`.

* Assignment direction

Assignment works from right to left:

```solidity
variableBeingChanged = newValue;
```

The variable on the left receives the value from the right.

```solidity
favouriteNumber = _favouriteNumber;
```

This means:

Store the temporary input inside the permanent state variable.

This would be wrong:

```solidity
_favouriteNumber = favouriteNumber;
```

It copies the old state variable value into the temporary parameter. It does not update the contract.

* Do all functions need parameters?

No. A function only needs a parameter when the caller must provide some information.

This function needs a parameter because the caller chooses the new number:

```solidity
function store(uint256 _favouriteNumber) public {
    favouriteNumber = _favouriteNumber;
}
```

This function does not need a parameter because it always adds six:

```solidity
function addSix() public {
    favouriteNumber = favouriteNumber + 6;
}
```

The function already knows what value to add.

* Data locations

* Memory

`memory` stores temporary, modifiable data while a function is running.

```solidity
function changeName(
    string memory _name
) public pure returns (string memory) {
    _name = "Amelie";
    return _name;
}
```

Changing `_name` only changes the temporary memory value.

* Calldata

`calldata` is temporary and read-only. It is commonly used for reference-type parameters in external functions.

```solidity
function addPerson(
    string calldata _name,
    uint256 _favouriteNumber
) external {
    personList.push(
        Person({
            name: _name,
            favouriteNumber: _favouriteNumber
        })
    );
}
```

You can read `_name`, but you cannot change it:

```solidity
_name = "Amelie";
```

That would fail because `calldata` is read-only.

Use `memory` when the temporary value may need to be changed.

Use `calldata` when the input is read-only.

* Storage

`storage` refers to permanent contract data stored on the blockchain.

```solidity
uint256 public favouriteNumber;
Person[] public personList;
```

State variables are automatically stored in `storage`.

A local storage reference can point directly to existing state data:

```solidity
function updateFirstPersonName(
    string memory _newName
) public {
    Person storage firstPerson = personList[0];
    firstPerson.name = _newName;
}
```

Changing `firstPerson` also changes the original person inside `personList`.

* Function types

### Regular state-changing function

A regular function can modify blockchain state.

```solidity
function store(uint256 _favouriteNumber) public {
    favouriteNumber = _favouriteNumber;
}
```

It uses neither `view` nor `pure` because it changes a state variable.

* Pure function

A pure function cannot read or modify blockchain state. It only works with parameters and local variables.

```solidity
function add(
    uint256 _firstNumber,
    uint256 _secondNumber
) public pure returns (uint256) {
    return _firstNumber + _secondNumber;
}
```

A pure function cannot return a state variable:

```solidity
return favouriteNumber;
```

That would fail because it reads contract state.

* View versus pure

Use `view` when the function reads contract state:

```solidity
function retrieve() public view returns (uint256) {
    return favouriteNumber;
}
```

Use `pure` when the function only uses parameters or local variables:

```solidity
function addSixToNumber(
    uint256 _number
) public pure returns (uint256) {
    return _number + 6;
}
```

Use neither when the function changes contract state:

```solidity
function store(uint256 _favouriteNumber) public {
    favouriteNumber = _favouriteNumber;
}
```
