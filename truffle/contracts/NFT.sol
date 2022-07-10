pragma solidity >=0.8.1 <0.9.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721PresetMinterPauserAutoId.sol"


/// Naming: a wrapper to any NFT - could be better tho
/// @dev - no max supply is specified for the contract so we can create as many as we want

contract NFTWrapper is Ownable, ERC721PresetMinterPauserAutoId {
    /// @dev this fires e,verytime an NFT is created
    event NewNFTWrapper(uint256 _tokenId, string _symbol);

    /// @dev implementation of EIP-2309, standardises 
    event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed fromAddress, address indexed toAddress);

    /// @dev this is set up to track how many changes the url has been changed
    event UrlChange(uint256 _tokenId);

    mapping(uint256 => address) private _reservedIds;

    /* /// @dev we define the structure of our nft */
    /* struct NFT { */
    /*     uint64 tokenId; //@dev this is for space saving, since it's not a production contract */
    /*     uint256 price; */
    /*     string reference; */
    /*     string url; */
    /* } */

    /* /// @dev tracking of nfts created */
    /* NFT[] nfts; */


    constructor(string memory _name, string memory _symbol) 
        ERC721(_name, _symbol) {
        _owner = msg.sender
    }


    function mint(string memory tokenURI)
        public
        returns (uint256)
    {
        /// @dev missing the required owner
        _tokenIds.increment();

        uint256 newItemId = _tokenIds.current();
        _mint(msg.sender, newItemId);
        _setTokenURI(newItemId, tokenURI);


        emit NewNFT(_newItemId, _symbol)
        return newItemId;
    }

    /// @dev the owner can reserve some NFT ids by token and mint them whenever
    ///      this makes minting all the more expensive but if the requirement is there
    ///      this is a strategy to reserve tokenIds for the team, giveaways, prizes, etc.
    function reserveNFTs(uint256[] memory _tokenIds) public onlyOwner {
        uint256 totalMinted = _tokenIds.current();
        for(i=0; i < _tokenIds.length; i++) {
            require(_tokenIds[i] > totalMinted, "That tokenId already exists");

            _reservedIds[_tokenIds[i]] = msg.sender;
        }
    }

    /// @dev a better implementation will incur in less gas costs, like a mapping
    function mintReserved(uint256 _idToMint) public onlyOwner {
        require(_reservedIds[_idToMint] == msg.sender);

    }
}
