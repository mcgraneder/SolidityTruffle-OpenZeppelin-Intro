//SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;
pragma experimental ABIEncoderV2;


//TO DO -- make withdrawal struct

contract MultiSigWallet {

    address[] owners;
    uint public limit;
    
    struct Transfer{
        uint amount;
        address payable receiver;
        uint approvals;
        bool hasBeenSent;
        uint id;
    }
    
    
    Transfer[] transferRequests;
    
    mapping(address => mapping(uint => bool)) approvals;
    mapping(address => uint)balance;
    
    
    modifier onlyOwners(){
        bool owner = false;
        for(uint i=0; i<owners.length;i++){
            if(owners[i] == msg.sender){
                owner = true;
            }
        }
        require(owner == true);
        _;
    }
    
    event TransferRequestCreated(uint _id, uint _amount, address _initiator, address _receiver);
    event ApprovalReceived(uint _id, uint _approvals, address _approver);
    event TransferApproved(uint _id);
    
    function addUsers(address _owners) public
    {
        for (uint user = 0; user < owners.length; user++)
        {
            require(owners[user] != _owners, "Already registered");
        }
        owners.push(_owners);
        
        //from the current array calculate the value of minimum consensus
        limit = owners.length - 1;
    }
    
    function removeUser(address _user) public
    {
        uint user_index;
        for(uint user = 0; user < owners.length; user++)
        {
            if (owners[user] == _user)
            {   
                user_index = user;
                require(owners[user] == _user);
            }
        }
        
        owners[user_index] = owners[owners.length - 1];
        owners.pop();
        //owners;
    }
    
    
    function getUsers() public view returns(address[] memory)
    {
        return owners;
    }
    
    function getApprovalLimit() public view returns (uint)
    {
        return (limit);
    }
    
    
    //Empty function
    function deposit() public payable onlyOwners
    {
        require(msg.value >= 0);
        require(owners.length > 1, "need to have more than one signer");
    
        balance[msg.sender] += msg.value;
    }
    
    
    //next we want to make a get balance function
    function getAccountBalance() public view returns(uint)
    {
        return balance[msg.sender];
    }
    
    
    function getContractBalance() public view returns(uint)
    {
        return address(this).balance;
    }
    
    
    //next we want to make q function to return the address of the wallet owner
    function getOwner() public view returns(address)
    {
        return msg.sender;
    }
    
    
    //Create an instance of the Transfer struct and add it to the transferRequests array
    function createTransfer(uint _amount, address payable _receiver) public onlyOwners {
        require(owners.length > 1, "need to have more than one signer");
        //require(msg.sender != _receiver);
        for (uint i = 0; i < owners.length; i++)
        {
            require(owners[i] != _receiver);
        //   if  (owners[i] == _receiver)
        //   {
        //       revert();
        //   }
        }
        emit TransferRequestCreated(transferRequests.length, _amount, msg.sender, _receiver);
        transferRequests.push(
            Transfer(_amount, _receiver, 0, false, transferRequests.length)
        );
        
    }
    
    
    
    function approve(uint _id) public onlyOwners {
        require(owners.length > 1, "need to have more than one signer");
        require(approvals[msg.sender][_id] == false);
        require(transferRequests[_id].hasBeenSent == false);
        
        approvals[msg.sender][_id] = true;
        transferRequests[_id].approvals++;
        
        emit ApprovalReceived(_id, transferRequests[_id].approvals, msg.sender);
    
        
    }
    
    
     //now we need to create a function to actually transfer the funds after the
    //transfer has been recieved
    function TransferFunds(uint _id) public returns(uint)
    {
        require(owners.length > 1, "need to have more than one signer");
        require(transferRequests[_id].approvals >= limit);
        
        if(transferRequests[_id].approvals >= limit)
        {
            transferRequests[_id].hasBeenSent = true;
            balance[msg.sender] -= transferRequests[_id].amount;
            balance[transferRequests[_id].receiver] += transferRequests[_id].amount;
            
        }
        return balance[msg.sender];
    }
    
    //after transfer is called our balance i < transaction amount thus we cannot withfraw
    //update amount after transfer function.
    function withdraw(uint _id, uint _amount) public onlyOwners returns (uint)
    {
        //take in amount and update struct 
        require(owners.length > 1, "need to have more than one signer");
        require(transferRequests[_id].approvals >= limit);
        
        if(transferRequests[_id].approvals >= limit)
        {
            transferRequests[_id].hasBeenSent = true;
            transferRequests[_id].receiver.transfer(_amount);
            emit TransferApproved(_id);
        }
        
        return balance[msg.sender];
        
    }
    
    
    function getApprovalState(uint _id) public view returns(uint)
    {
        return transferRequests[_id].approvals;
    }
    
    
    //Should return all transfer requests
    function getTransferRequests() public view returns (Transfer[] memory){
       
        return transferRequests;
    }
}