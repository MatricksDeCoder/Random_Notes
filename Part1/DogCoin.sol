// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/*
ERC20 with list of all holders 
*/

contract DogCoin is ERC20 {

    address[] public holders;
    mapping(address => bool) public isHolder;
    // other possibility is to use EnumerableSet
    // question about those whose balance falls to zero are they still considered holders?
    constructor() ERC20("DogCoin", "DOG"){
        _mint(msg.sender,1000*10**18);
        _addToHolders(msg.sender);
    }

    function _addToHolders(address _address) internal {
        if(!isHolder(_address)) { //add holder
            holders.push(msg.sender);
        }
    }

    // override _mint function - for holders update 
    function _mint(address account, uint256 amount) internal virtual override {
        require(account != address(0), "ERC20: mint to the zero address");

        _beforeTokenTransfer(address(0), account, amount);

        _totalSupply += amount;
        _balances[account] += amount;
        _addToHolders(account); // adjustment for holders 
        emit Transfer(address(0), account, amount);

        _afterTokenTransfer(address(0), account, amount);
    }

    // overide _burn function - for holders update 
    function _burn(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: burn from the zero address");

        _beforeTokenTransfer(account, address(0), amount);

        uint256 accountBalance = _balances[account];
        require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
        unchecked {
            _balances[account] = accountBalance - amount;
        }
        _totalSupply -= amount;
        _addToHolders(account); // adjustment for holders 

        emit Transfer(account, address(0), amount);

        _afterTokenTransfer(account, address(0), amount);
    }

    // override _transfer function - for holders update 
    function _transfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual override {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");

        _beforeTokenTransfer(from, to, amount);

        uint256 fromBalance = _balances[from];
        require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
        unchecked {
            _balances[from] = fromBalance - amount;
        }
        _balances[to] += amount;
        _addToHolders(_to);

        emit Transfer(from, to, amount);

        _afterTokenTransfer(from, to, amount);
    }

}