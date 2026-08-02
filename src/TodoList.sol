//SPDX-License-Identifier: MIT

pragma solidity 0.8.18;

//creating a basic contract for creating, reading and updating and completing todo items
contract TodoList {

    //creating a struct for each todo item
    struct Todo {
        uint256 id;
        string description;
        bool completed;
    }

    //storing all the todos in a dynamic array
    Todo[] public todos;

    //creating a function to create a new todo and add it to the array
    function createTodo(string memory _description) public {
        //checking  that it has a description
        require(bytes(_description).length > 0, "Description cannot be empty");

        //setting the current array length to the new todo's ID
        uint256 newId = todos.length;

        //creating a new todo struct and adding it to the array
        todos.push(Todo({id: newId, description: _description, completed: false}));

    }

    //creating a function to return one todo using its array index
    function getTodo(uint256 _index) public view returns (Todo memory) {
        //checking that the requested index exists
        require(_index < todos.length, "Invalid todo index");

        //returning the temporary copy of the selected Todo struct
        return todos[_index];
    }

    //changing the description of an existing todo
    function updateTodo(uint256 _index, string memory _newDescription) public {
        //checking that the requested index exists
        require(_index < todos.length, "Invalid todo index");

        //preventing changing the description to an empty string 
        require(bytes(_newDescription).length > 0, "Description cannot be empty");

        //selecting the todo and changing the description
        todos[_index].description = _newDescription;
    }

    //creating a function that marks a todo as completed
    function completeTodo(uint256 _index) public {
        //checking that the requested index exists
        require(_index < todos.length, "Invalid todo index");

        //changing completed from false to true
        todos[_index].completed = true;
    }

    //returning the total number of todos (the stuff we have to do)
    function getTodoCount() public view returns (uint256) {
        return todos.length;
    }

}