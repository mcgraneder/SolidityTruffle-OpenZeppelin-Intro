// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract HelloWorld {

    string public my_string = "hello world";

    function setString(string memory newMessage) public {
        my_string = newMessage;
    }

    function hello() public view returns(string memory) {

        return my_string;
    }
}

