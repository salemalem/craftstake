pragma solidity ^0.5.0;

contract Token {
    function transferFrom(address from, address to, uint256 value) public returns (bool){}

    function transfer(address to, uint256 value) public returns (bool){}
}

contract Locker {
    uint256 constant public expirationDate = 1630432800; // 1st September 2021
    address public owner;
    
    Token public token;
    
    // provide token address to the locker constructor
    constructor (address tokenAddress) public {
        owner = msg.sender;
        token = Token(tokenAddress);
    }
    
    function lockTokens(uint256 value) public returns(bool success) {
        require(owner == msg.sender, "Only owner can lock tokens.");
        token.transferFrom(msg.sender, address(this), value);
    }
    
    function withdrawTokens(uint256 value) public returns(bool success) {
        require(owner == msg.sender);
        require(now <= expirationDate, "expirationDate is not reached yet");
        token.transfer(msg.sender, value);
        
    }
}