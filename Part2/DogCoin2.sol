// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.5/contracts/token/ERC20/ERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.5/contracts/access/Ownable.sol";

/*
DRAFT DRAFT DRAFT ROUGH THOUGHTS
ERC20 with list of all holders => Simple case anyone ever received token added to list and remains in list 
When a user's balance falls to zero, remove them from the holders array
The holders array should not contain any gaps
Add events to indicate users being added or removed from the holders array

function testRemove(uint256 _index) public {
if (_index != 0) {
uint256 lastIndex = holders.length - 1;
if (lastIndex != _index) {
holders[_index] =
holders[lastIndex];
}
}
holders.pop();
}
*/

// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.5/contracts/token/ERC20/ERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.5/contracts/access/Ownable.sol";

/*
ERC20 with list of all holders => Simple case anyone ever received token added to list and remains in list 
*/

contract DogCoin is ERC20, Ownable {
    
    uint public numHolders;
    address[] public holders;
    mapping(address => bool) public isHolder;
    mapping(address => uint) private indexHolder;

    event HolderIn(address holder, uint time);
    event HolderOut(address holder, uint time);

    constructor() ERC20("DogCoin", "DOG"){
        _mint(msg.sender,1000*10**18);
        _addToHolders(msg.sender);
    }

    function _updateHolders(address _address) internal {
        if(!isHolder[_address]) { //add holder
            _addToHolders(_address);
        } 
        if(balanceOf(_address) == 0) {
            _removeFromHolders(_address);
        }
    }

    function _addToHolders(address _address) internal {
        if(balanceOf(_address) > 0) {
            holders.push(_address);
            indexHolder[_address] = numHolders;
            numHolders++;
        }
    }

    function _removeFromHolders(address _address) internal {
        uint index = indexHolder[_address];
        holders[index] = holders[numHolders- 1];
        indexHolder[holders[numHolders] -1] = index;
        holders.pop();
    }

    function mint(address account, uint256 amount) external onlyOwner {
        _updateHolders(account);
        _mint(account, amount);
    }

    function burn(address account, uint256 amount) external onlyOwner {
        _updateHolders(account);
        _burn(account, amount);
    }
    
 function transfer(address to, uint256 amount) public override returns (bool) {
        address owner = _msgSender();
        _transfer(owner, to, amount);
        _updateHolders(to);
        _updateHolders(msg.sender);
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
        _updateHolders(to);
        _updateHolders(from);
        return true;
  }


}
