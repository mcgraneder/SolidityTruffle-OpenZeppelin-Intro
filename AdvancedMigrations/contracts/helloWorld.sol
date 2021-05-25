// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract helloWorld {
  
  string message = "Hello World";

  function getMessage() public view returns (string memory) {

      return message;
  }

  function setMessage(string memory newMessage) public payable {

      //require(msg.value > 1000000);
      message = newMessage;
  }

}
