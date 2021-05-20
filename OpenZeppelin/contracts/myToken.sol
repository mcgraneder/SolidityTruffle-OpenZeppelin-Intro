// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "../node_modules/@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "../node_modules/@openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol";
import "../node_modules/@openzeppelin/contracts/access/Ownable.sol";

//our token to be mintable
//our token to be burnable
//our token to be pausable
//our token to have a cap


//here ERC20Cappped inherits from ERC20 so we only referance ERC20Capped
contract MyToken is ERC20, Ownable {


    bool private _paused;
    uint256 private _cap;
    //the ERC20 contratc requires us to define a constructor
    //however we do need to specify the ERC20 and ERC20Capped constructors
    constructor(uint256 cap)  {
        require(cap > 0, "The inital cap must be equal to a value greater than 0");
        _cap = cap;
        _paused = false;
    }


    //all required events
    event Minted(address minter, uint256 amount);
    event capIncreased(address by, uint256 amount);
   

    function cap() public view returns(uint256) {

        return _cap;
    }

    //function that modifies cap only callable by admin
    function IncreaseCap(uint256 _amount) public onlyOwner returns (uint256 ) {

        require(_amount > 0);
        
        //increase cap
        _cap = _cap + _amount;
        //emmit the cap increase transfer event to log
        emit capIncreased(msg.sender, _amount);

        return _cap;
    }

    //execute ERC20Capped outside the constructor
    function _mint(uint256 _amount) public returns(bool _success) {
        
        require(!_paused);
        //the mint is called from ERC20Capped which inherits mint
        //from ERC20 but also has its own functionality on top namely
        //the cap requirment
        _mint(msg.sender, _amount);
        emit Minted(msg.sender, _amount);
        _success = true;

        return _success;

    }
asmcnlkascnla
    
    //transfer funds function
    function transfer(address recipient, uint256 amount) public virtual returns (bool _success) {

        require(recipient == msg.sender);
        //only allow trasnfers when the contratc is not paused
        require(!_paused);
        //call the ERC20.sol transfer function
        ERC20.transfer(recipient, amount);
        _success = true;

        return _success;
    }

    //returns true if contract is paused, false otherwise
    function isPaused() public view returns (bool) {
        return _paused;

    }

    //function that pauses the contract. Can only be called by owner
    function pause() public onlyOwner {

        require(!_paused, "This contratc is already paused" );
        //set _paused to true
        _paused = true;    
    }

    //function that pauses the contract. Can only be called by owner
    function unpause() public onlyOwner {

        require(_paused, "This contratc is already unpaused" );
        //set _paused to true
        _paused = false;    
    }
    
    //function which burns tokens
    function burn(address account, uint256 amount) public virtual {
        //require(account == msg.sender);
        //calls the burn function in the ERC20 Contratc
        _burn(account, amount);
    }

    //get balance of account pased in
    function accountBalance(address account) public view returns (uint256) {

        //calls the balanceOf function in ERC20.sol
        return balanceOf(account);
    }

    //require the cap check here. This funcion gets executed in the ERC20._mint function so if the cap
    //is exceded an error will throw
    function _beforeTokenTransfer(address from, address to, uint256 amount) internal override virtual {
        //require that the current total supply plus the amount does
        //not exceed the cap
        require(totalSupply() + amount <= _cap, "Cap is exceeded");

        //call the ERC20 beforeTokenTransfer function
        ERC20._beforeTokenTransfer(from, to, amount);

        
    }
}