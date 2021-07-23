pragma solidity ^0.4.26 < 0.5.0;

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
        symbol = "CRF";
    }
    
    function _transfer(address _from, address _to, uint256 _value) internal {
        require(_to!=0x0);
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
    
    // 3rd party can spend someone's fund if that person approved it using approve function
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        require(_value <= allowance[_from][msg.sender]);
        _transfer(_from, _to, _value);

        return true;
    }
    
    // approve 3rd party to spend your tokens
    function approve(address _spender, uint256 _value) public returns (bool success) {
        allowance[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        
        return true;
    }
}