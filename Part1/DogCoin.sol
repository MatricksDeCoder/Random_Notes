// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.5/contracts/token/ERC20/ERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.5/contracts/access/Ownable.sol";

/*
DRAFT DRAFT DRAFT ROUGH THOUGHTS
ERC20 with list of all holders => Simple case anyone ever received token added to list and remains in list 
*/

contract DogCoin is ERC20, Ownable {

    address[] public holders;
    mapping(address => bool) public isHolder;
    // other possibility is to use EnumerableSet
    // question about those whose balance falls to zero are they still considered holders?
    constructor() ERC20("DogCoin", "DOG"){
        _mint(msg.sender,1000*10**18);
        _addToHolders(msg.sender);
    }

    function _addToHolders(address _address) internal {
        if(!isHolder[_address]) { //add holder
            holders.push(msg.sender);
        }
    }
    function mint(address account, uint256 amount) external onlyOwner {
        _addToHolders(account);
        _mint(account, amount);
    }

    function burn(address account, uint256 amount) external onlyOwner {
        _addToHolders(account);
        _burn(account, amount);
    }
    
 function transfer(address to, uint256 amount) public override returns (bool) {
        address owner = _msgSender();
        _transfer(owner, to, amount);
        _addToHolders(to);
        return true;
 }

 function transferFrom(
        address from,
        address to,
        uint256 amount
    ) public virtual override returns (bool) {
        address spender = _msgSender();
        _spendAllowance(from, spender, amount);
        _transfer(from, to, amount);
        _addToHolders(to);
        return true;
  }


}