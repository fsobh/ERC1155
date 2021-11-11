pragma solidity ^0.6.7;

contract ERC1155 {

//indexed allows you to search by that field

event ApprovalForAll(address indexed account, address indexed operator, bool approved);

event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);

event TransferBatch(address operator, address from, address to, uint256 [] _ids, uint256 [] _values)

event URI(uint256 value, uint256 id);
// tokenID , address, balance  - tracks balances
mapping(uint256 => mapping(address =>uint256)) internal _balances;

// Owners address , Operator address , approval boolean - to check if an operator is approved to op the owners token
mapping(address => mapping(address => bool)) private _operatorApprovals;

//gets balance of an accounts tokens
function balanceOf(address account, uint256 id) public view returns(uint256){
    
    require(account != address(0), 'Address is not valid');

    return _balances[id][account];
}

//gets balance of MULTIPLE accounts tokens
function balanceOfBatch(address [] memory accounts, uint256 [] memory ids) public view returns (uint256 []){

    require(accounts.length == ids.length, 'Lengths of accounts and ids are not the same');

    //create array with dynamic length to fetch balances - must match the length of accounts
    uint256 [] memory batchBlances = new uint256[accounts.length];

    for(uint256 i = 0 ; i < accounts.length ; i++){

        batchBlances[i] = balanceOf(accounts[i],ids[i]);
    }

    return batchBlances;

}
//checks if an address is an noperator FOR ANOTHER address
function isApprovedForAll(address account, address operator) public view returns (bool){

    require(account != address(0) || operator != address(0) , 'Operator/Owner Address is not valid');
    

    return _operatorApprovals[account][operator];
}

//Enable/ diable an operator to operate on an Owners assets
function setApprovalForAll(address operator, bool approved) public {

    require(operator != address(0),'Operator Address is not valid');
    
    _operatorApprovals[msg.sender][operator] = approved;

    emit ApprovalForAll(msg.sender, operator,approved);

}
//private --> not open for public use outside contract (not even inherited ones)
function _transfer(address from, address to, uint256 id, uint256 amount) private {

    uint256 fromBlance = _balances[id][from]; // get the amount of NFTS this address is holding

    require(fromBlance >= amount ,'Insufficient Funds ');

    //update balances accordingly
    _balances[id][from] = fromBlance - amount;
    _balances[id][to] += amount;


}


function safeTransferFrom(address from, address to, uint256 id, uint256 amount, bytes memory data){

    
    require(from == msg.sender || isApprovedForAll(from,msg.sender),'Sender is not owner or approved to transfer');

    require(to != address(0), 'Not a valid Recieving Address');

    _transfer(from, to, id, amount);

    emit TransferSingle(msg.sender,from,to,id,amount);

    //check if recieved
    require(_checkOnERC1155Recieved(data),'Reciever not implemented');
}



//transfer multiple NFTS from one address to another
function safeBatchTransferFrom(address from, address to, uint256 [] memory ids, uint256 [] memory amounts, bytes memory data) public
{

    require(from == msg.sender || isApprovedForAll(from,msg.sender),'Sender is not owner or approved to transfer');

    require(to != address(0), 'Not a valid Recieving Address');

    require(ids.length == amounts.length, 'Ids and ammounts dont correspond in length');


    for(uint256 i = 0 ; i < ids.length; i++){
        
        uint256 id = ids[i];

        uint256 amount = amounts[i];

        _transfer(from,to,id,amount);

    }

    emit TransferBatch(msg.sender,from,to,ids,amounts);

    //check if recieved
    require(_checkOnBatchERC1155Recieved(data),'Reciever not implemented');

}

//ERC-165 Complient
//tell everyone that we support erc 1155 functions
//interfaceID == 0xd9b67a26 -- This will never change
//OPEN SEA USE THIS TO CHECK UR CONTRACT TYPE
function supportsInterface(bytes4 interfaceId) public pure virtual returns (bool){
    return interfaceId == 0xd9b67a26;
}

//dummy functions for now
function _checkOnERC1155Recieved(bytes memory data) private pure returns(bool){

    return true;

}

function _checkOnBatchERC1155Recieved(bytes memory data) private pure returns(bool){

    return true;

}

}