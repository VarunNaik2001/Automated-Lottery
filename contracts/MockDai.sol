// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract MockDai  {
    string private name;
    string private symbol;
    uint private decimals;
    mapping (address => uint) public balances;
    uint private totalSupply;

    constructor(){
    name = "Dai";
    symbol = "Dai";
    decimals = 18;
    totalSupply = 0;

    }
    function mintDai() public{
        balances[msg.sender] += 1000;
        totalSupply += 1000;
    }

    function getBalance(address _owner) public returns(uint){
        return balances[_owner];
    }

    function transfer(address _to, uint256 _value) public returns (bool success){
        require(balances[msg.sender]>=_value,"value exceeds balance");
        balances[msg.sender]-= _value;
        balances[_to] += _value;

    }


    function getName() public returns(string memory){
        return name;
    }

    function getSymbol() public returns(string memory ){
        return symbol;
    }

     function getTotalSupply() public view returns(uint){
        return totalSupply;
    }

    function getDecimals() public view returns(uint){
        return decimals;
    }

}