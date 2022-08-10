// SPDX-License-Identifier: MIT

pragma solidity 0.8.7;

contract Main {
  string private greeting;

  constructor() {
    greeting = "Hello World!";
  }

  function getGreeting() public view returns (string memory) {
    return greeting;
  }
}
