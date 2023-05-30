//SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.14;

interface IERC20{

    function totalSuply() external view returns(uint256);

    function balanceOf (address account) external view returns (uint256);

    function transfer (address to, uint256 amount) external returns (bool);

    function allowance(address owner, address spender) external view returns(uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom (address from, address to, uint256 amount) external returns (bool);


    event Transfer (address indexed from, address indexed to, uint256 amount);

    event Approval(address indexed from, address indexed  to, uint256 amount);
}

contract ERC20 is IERC20{
    //Variables
    /* Account's balances. Number of tokens storage in account */
    mapping(address => uint256) private _balances;

    /* Number  of transfer taht the account could make to another account */
    mapping(address => mapping(address =>uint256)) private _allowances;

    uint private _totalSuply;
    string private _name;
    string private _symbol;

    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
  
    }

    function viewName() public view virtual returns (string memory){
        return _name;
    }
    function viewSymbol() public view virtual returns (string memory){
        return _symbol;
    }

    function decimals () public view virtual returns(uint8){
        return 18;
    }

    //Number of tokens in the net
    function totalSuply() public view virtual override returns(uint256){
        return _totalSuply;
    }

    //Retirns the sold that disposes the account
    function balanceOf (address account) public view virtual override returns (uint256){
        return _balances[account];
    }
    // Transfert directly from somme account to another
    function transfer (address to, uint256 amount) public virtual override returns (bool){
        address owner = msg.sender;
        _transfer(owner, to, amount);
        return true;
    }    
    // The necessary quantity to make the transfert
    function allowance(address owner, address spender) public view  virtual override returns (uint256){
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount) public virtual override returns (bool){
        address owner = msg.sender;
        _approve(owner, spender, amount);
        return true;
    }

    function transferFrom(address from, address to, uint256 amount) public virtual override returns (bool){
        address spender = msg.sender;
        _spendAllowance(from, spender, amount);
        _transfer(from, to, amount);
        return true;
    }



    //Internal functions

    function _transfer(address from, address to, uint256 amount) internal virtual{
        
        require(from!= address(0), "ERC20: transfer from the zero address");
        require(to!= address(0), "ERC20: to from the zero address");

        _beforeTokenTransfer(from, to, amount);

        uint256 fromBalance = _balances[from];
        require(fromBalance >= amount, "ERC20: transfer amount exceds balance");
        unchecked
        {
            _balances[from] = fromBalance-amount;
        }
        _balances[to] += amount;
        emit Transfer(from, to, amount);
        _afterTokenTransfer(from, to,  amount);
    }

    function _approve(address owner, address spender, uint256 amount) internal virtual{

        require(owner!= address(0), "ERC20: transfer from the zero address");
        require(spender!= address(0), "ERC20: to from the zero address");

        _allowances[owner][spender] = amount;
        emit Approval (owner, spender, amount);
    }

    function _spendAllowance(address owner, address spender, uint256 amount) internal virtual{

        uint256 currentAllowance= allowance(owner, spender);

        if(currentAllowance !=type(uint256).max){
            require(currentAllowance >= amount, "ERC20: insuficient balance");
            unchecked{
                _approve(owner, spender, currentAllowance - amount);
            }
        }
    }

    function increaseAllowance (address spender, uint256 addValue) public virtual returns (bool){

        address owner = msg.sender;

        _approve(owner, spender, allowance(owner, spender) + addValue);
        return true;
    }

    function decreaseAllowance (address spender, uint256 subtractedValue) public virtual returns (bool){

        address owner = msg.sender;
        uint256 currentAllowance = allowance(owner, spender);

        require (currentAllowance>= subtractedValue, "ECR20: decreased allowance bellow 0");
        unchecked{
            _approve(owner, spender, currentAllowance- subtractedValue);
        }
    }

    //Generate new tokens to put it in circualtion
    function _mint( address account, uint256 amount) internal virtual{
        require(account!= address(0), "ERC20: mint to the 0 address");
        _beforeTokenTransfer(address(0), account, amount);
        _totalSuply += amount;

        unchecked{
            _balances[account] += amount;
        }
        emit Transfer(address(0), account, amount);
          _afterTokenTransfer(address(0), account, amount);
    }
    //Destroy tokens
     function _burn( address account, uint256 amount) internal virtual{
        require(account!= address(0), "ERC20: mint to the 0 address");
        _beforeTokenTransfer(address(0), account, amount);

        uint256 accountBalance = _balances[account];
        require (accountBalance >= amount, "ERC20 burn amount exceds balance");

        unchecked {
            _balances[account] = accountBalance- amount;
            _totalSuply -= amount;
        }
        emit Transfer(account, address(0), amount);
        _afterTokenTransfer(address(0), account, amount);


     }
     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual{}
     function _afterTokenTransfer(address from, address to, uint256 amount) internal virtual{}

    

}
