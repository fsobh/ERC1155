pragma solidity ^0.6.7;
import "./ERC1155.sol";

contract Skater is ERC1155 {

    
    string public name ; //Namae of collection

    string public symbol; //Symbol for collection

    uint256 public tokenCount; //how many NFTS we have

    mapping (uint256 => string) private _tokenURIs; //mappings to the NFT's Meta data

    constructor(string memory _name, string memory _symbol){

        name = _name;
        symbol = _symbol;
    }

    function uri(uint256 tokenId) public returns (string memory){

        return _tokenURIs[tokenId];
    }

    function mint(uint256 amount, string memory uri)public {
        
        require(msg.sender != address(0), 'Mint to Zero - NBot Valid')

        

        tokenID+=1; // use VRF oracle for this -- gonna increment like this for now
        _balances[tokenID][msg.sender] += amount;
        _tokenURIs[tokenID] = _uri;

        emit TransferSingle(msg.sender,address(0), msg.sender, tokenID, amount);

    }
    function supportsInterface(bytes4 interfaceId) public pure override returns (bool){
    return interfaceId == 0xd9b67a26 || interfaceId == 0x0e89341c ; //(2nd is for URI's)
    }
}

}

