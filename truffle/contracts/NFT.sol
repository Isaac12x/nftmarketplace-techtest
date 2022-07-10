// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.1 <0.9.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "./IERC4907.sol";

abstract contract ConfiguredERC721 is ERC721URIStorage, Ownable, Pausable, IERC4907 {}

/**
 * @dev {ERC721} token, including:
 *
 *  - a minter role that allows for token minting (creation)
 *  - a pauser role that allows to stop all token transfers
 *  - token ID and URI
 *  - no max supply so we can create as many NFTs as we want
 *
 *    Naming: a wrapper to any NFT - could be better
*/
contract NFTWrapper is ConfiguredERC721 {
    /// @dev this fires everytime an NFT is created
    event NewNFT(uint256 _tokenId);

    /// @dev implementation of EIP-2309, standardises 
    event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed fromAddress, address indexed toAddress);

    /// @dev this is set up to track how many changes the url has been changed
    event UrlChange(uint256 _tokenId);

    // Optional mapping for token URIs
    mapping(uint256 => string) private _tokenURIs;

    using Counters for Counters.Counter;
    Counters.Counter  _tokenIds;

    struct UserInfo 
    {
        address user;   // address of user role
        uint64 expires; // unix timestamp, user expires
    }

    mapping (uint256  => UserInfo) internal _users;
    mapping(uint256 => address) private _reservedTokenIds;

    constructor(string memory name_, string memory symbol_) 
        ERC721(name_, symbol_) {
    }

    function transferFrom(
                          address from,
                          address to,
                          uint256 tokenId
    ) public virtual override {
        //solhint-disable-next-line max-line-length
        require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
        _transfer(from, to, tokenId);
        emit ConsecutiveTransfer(tokenId, tokenId, from, to);
    }


    function mint(string memory tokenURI)
        public
        returns (uint256)
    {
        /// @dev if implementing reserveNFTs, add a required check here missing the required owner
        _tokenIds.increment();

        uint256 newItemId = _tokenIds.current();
        _mint(msg.sender, newItemId);
        _setTokenURI(newItemId, tokenURI);


        emit NewNFT(newItemId);
        return newItemId;
    }

    /// @notice set the user and expires of a NFT
    /// @dev The zero address indicates there is no user
    /// Throws if `tokenId` is not valid NFT
    /// @param user  The new user of the NFT
    /// @param expires  UNIX timestamp, The new user could use the NFT before expires
    function setUser(uint256 tokenId, address user, uint64 expires) public virtual{
        require(_isApprovedOrOwner(msg.sender, tokenId), "ERC4907: transfer caller is not owner nor approved");
        UserInfo storage info =  _users[tokenId];
        info.user = user;
        info.expires = expires;
        emit UpdateUser(tokenId, user, expires);// @dev this event will be used to update the frontend until when the NFT is unavailable to be rented
    }

    /// @notice Get the user address of an NFT
    /// @dev The zero address indicates that there is no user or the user is expired
    /// @param tokenId The NFT to get the user address for
    /// @return The user address for this NFT
    function userOf(uint256 tokenId) public view virtual returns(address){
        if( uint256(_users[tokenId].expires) >=  block.timestamp){
            return  _users[tokenId].user;
        }
        else{
            return address(0);
        }
    }

    /// @notice Get the user expires of an NFT
    /// @dev The zero value indicates that there is no user
    /// @param tokenId The NFT to get the user expires for
    /// @return The user expires for this NFT
    function userExpires(uint256 tokenId) public view virtual returns(uint256){
        return _users[tokenId].expires;
    }

    /// @dev See {IERC165-supportsInterface}.
    function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
        return interfaceId == type(IERC4907).interfaceId || super.supportsInterface(interfaceId);
    }

    /// @dev the owner can reserve some NFT ids by token and mint them whenever
    ///      this makes minting all the more expensive but if the requirement is there
    ///      this is a strategy to reserve tokenIds for the team, giveaways, prizes, etc.
    /* function reserveNFTs(uint256[] memory _tokenIds) public onlyOwner { */
    /*     uint256 totalMinted = _tokenIdTrackers.current(); */
    /*     for(i=0; i < _tokenIdTrackers.length; i++) { */
    /*         require(_tokenIds[i] > totalMinted, "That tokenId already exists"); */

    /*         _reservedTokenIds[_tokenId[i]] = msg.sender; */
    /*     } */
    /* } */



    /// @dev a better implementation will incur in less gas costs, like a mapping
    /* function mintReserved(uint256 _idToMint) public onlyOwner { */
    /*     require(_reservedTokenIds[_idToMint] == msg.sender); */

    /* } */
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual override(ERC721) {
        super._beforeTokenTransfer(from, to, tokenId);

        require(!paused(), "ERC721Pausable: token transfer while paused");
    }

}
