pragma solidity ^0.5.0;

contract TRC20 {

    string public name; // token name
    string public symbol; // token symbol
    uint8 public decimals;
    uint256 public totalSupply;
    address public owner;
    
    mapping (address => uint256) public balanceOf;
    mapping (address => mapping (address=> uint256)) public allowance;
    
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed _owner, address indexed _spender, uint256 value);
    event EcoBurn(address indexed from, uint256 value);
    
    constructor() public {
        decimals = 8;
        totalSupply = 1000000*10**uint256(decimals);
        owner = msg.sender;
        balanceOf[owner] = totalSupply;
        name = "CraftStake";
        symbol = "CRS";
    }
    
    function _transfer(address _from, address _to, uint256 _value) internal {
        require(_to!=address(0));
        require(balanceOf[_from] >= _value);
        require(balanceOf[_to] + _value >= balanceOf[_to]);
        
        uint previousBalances = balanceOf[_from] + balanceOf[_to];
        
        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;
        
        emit Transfer(_from, _to, _value);
        
        assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
    }
    
    function transfer(address _to, uint256 _value) public returns(bool success) {
        _transfer(msg.sender, _to, _value);
        return true;
    }
    
    // spend 3rd party's approved token amount
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        require(allowance[_from][msg.sender] >= _value);
        allowance[_from][msg.sender] -= _value;
        _transfer(_from, _to, _value);
        
        return true;
    }
    
    // approve 3rd party to spend/ecoburn your tokens
    function approve(address _spender, uint256 _value) public returns (bool success) {
        allowance[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        
        return true;
    }
    
    // disappear from blockchain supply forever
    function ecoburn(uint256 _value) public returns (bool success) {
        require(balanceOf[msg.sender] >= _value);
        balanceOf[msg.sender] -= _value;
        totalSupply -= _value;
        
        emit EcoBurn(msg.sender, _value);
        
        return true;
    }
    
    // eco burn tokens of 3rd party
    function ecoburnFrom(address _from, uint256 _value) public returns (bool success) {
        require(balanceOf[_from] >= _value);
        require(allowance[_from][msg.sender] >= _value);
        
        balanceOf[_from] -= _value;
        allowance[_from][msg.sender] -= _value;
        totalSupply -= _value;
        
        emit EcoBurn(_from, _value);
        
        return true;
    }
}