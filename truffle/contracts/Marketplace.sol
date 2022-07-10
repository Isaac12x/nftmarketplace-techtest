// SPDX-License-Identifier: UNLICENSED
// code from https://trufflesuite.com/guides/nft-marketplace/#my-nftsjs
// modifications mine.

pragma solidity >=0.8.1 <0.9.0;

import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "./IERC4907.sol";

contract FuncMarketplace is ReentrancyGuard{
  using Counters for Counters.Counter;

  Counters.Counter private _nftsSold;
  Counters.Counter private _nftsRented;
  Counters.Counter private _nftCount;

  uint256 public LISTING_FEE = 0.0001 ether;
  uint256 public RENT_FEE = 0.0002 ether;
  uint256 public SALE_FEE = 0.001 ether;
  address payable private _marketOwner;

  mapping(uint256 => NFT) private _idToNFT;
  mapping (address => uint256) pendingWithdrawals;

  struct NFT {
    address nftContract;
    uint256 tokenId;
    address payable seller;
    address payable owner;
    uint256 price;
    uint256 rentPrice;
    bool listed;
  }

  event NFTListed(
    address nftContract,
    uint256 tokenId,
    address seller,
    address owner,
    uint256 price
  );

  event NFTSold(
    address nftContract,
    uint256 tokenId,
    address seller,
    address owner,
    uint256 price
  );

  event NFTRented(
    address nftContract,
    uint256 tokenId,
    address seller,
    address owner,
    uint256 price,
    uint256 durationInMinutes   /// @dev terms
                  );

  constructor() {
    _marketOwner = payable(msg.sender);
  }

  // List the NFT on the marketplace
  function listNft(address _nftContract, uint256 _tokenId, uint256 _salePrice, uint256 _rentPrice) public payable nonReentrant {
      require(_salePrice > 0, "Price must be at least 1 wei");
      require(_rentPrice > 0, "Price must be at least 1 wei");
    require(msg.value == LISTING_FEE, "Not enough ether for listing fee");

    pendingWithdrawals[payable(msg.sender)] = msg.value - LISTING_FEE;
    pendingWithdrawals[_marketOwner] = msg.value;

    IERC721(_nftContract).transferFrom(msg.sender, address(this), _tokenId);    
    _nftCount.increment();

    _idToNFT[_tokenId] = NFT(
      _nftContract,
      _tokenId, 
      payable(msg.sender),
      payable(address(this)),
      _salePrice,
      _rentPrice,
      true

    );

    emit NFTListed(_nftContract, _tokenId, msg.sender, address(this), _salePrice);
  }

  // Buy an NFT
  function buyNft(address _nftContract, uint256 _tokenId) public payable nonReentrant {
    NFT storage nft = _idToNFT[_tokenId];
    require(msg.value >= nft.price+SALE_FEE, "Not enough ether to cover asking price and sale fee");

    address payable buyer = payable(msg.sender);
    payable(nft.seller).transfer(msg.value);
    IERC721(_nftContract).transferFrom(address(this), buyer, nft.tokenId);
    _marketOwner.transfer(LISTING_FEE);
    nft.owner = buyer;
    nft.listed = false;

    _nftsSold.increment();
    emit NFTSold(_nftContract, nft.tokenId, nft.seller, buyer, msg.value);
  }

  // Resell an NFT purchased from the marketplace
  function resellNft(address _nftContract, uint256 _tokenId, uint256 _price) public payable nonReentrant {
    require(_price > 0, "Price must be at least 1 wei");
    require(msg.value == LISTING_FEE, "Not enough ether for listing fee");

    IERC721(_nftContract).transferFrom(msg.sender, address(this), _tokenId);

    NFT storage nft = _idToNFT[_tokenId];
    nft.seller = payable(msg.sender);
    nft.owner = payable(address(this));
    nft.listed = true;
    nft.price = _price;

    _nftsSold.decrement();
    emit NFTListed(_nftContract, _tokenId, msg.sender, address(this), _price);
  }

  function rentNft(address _nftContract, uint256 _tokenId, uint256 _price, uint64 _expiry) public payable nonReentrant {
      require(_price > 0, "Price must be at least 1 wei");
      require(msg.value >= (RENT_FEE + _price), "Not enough ether to cover the rent and fee");
      NFT storage nft = _idToNFT[_tokenId];

      pendingWithdrawals[payable(nft.owner)] = msg.value - _price; // this should be the pricy
      if (msg.value > RENT_FEE) {
          pendingWithdrawals[payable(msg.sender)] = msg.value - RENT_FEE; // reminder
      }
      pendingWithdrawals[_marketOwner] = msg.value; /// fee


      IERC4907(_nftContract).setUser(_tokenId, msg.sender, _expiry);

      _nftsRented.increment();
      emit NFTRented(_nftContract, _tokenId, msg.sender, address(this), _price, _expiry);
  }

  function getListingFee() public view returns (uint256) {
     return LISTING_FEE;
  }

  function getSaleFee() public view returns (uint256) {
     return SALE_FEE;
  }

  function getRentFee() public view returns (uint256) {
     return RENT_FEE;
  }

  function getListedNfts() public view returns (NFT[] memory) {
    uint256 nftCount = _nftCount.current();
    uint256 unsoldNftsCount = nftCount - _nftsSold.current();

    NFT[] memory nfts = new NFT[](unsoldNftsCount);
    uint nftsIndex = 0;
    for (uint i = 0; i < nftCount; i++) {
      if (_idToNFT[i + 1].listed) {
        nfts[nftsIndex] = _idToNFT[i + 1];
        nftsIndex++;
      }
    }
    return nfts;
  }

  function getRented() public view returns (NFT[] memory) {
      uint256 nftCount = _nftCount.current();
      uint256 unsoldNftsCount = nftCount - _nftsSold.current();

      NFT[] memory nfts = new NFT[](unsoldNftsCount);
      uint nftsIndex = 0;
      for (uint i = 0; i < nftCount; i++) {
          if (_idToNFT[i + 1].listed) {
              nfts[nftsIndex] = _idToNFT[i + 1];
              nftsIndex++;
          }
      }
      return nfts;
  }

  function getMyNfts() public view returns (NFT[] memory) {
    uint nftCount = _nftCount.current();
    uint myNftCount = 0;
    for (uint i = 0; i < nftCount; i++) {
      if (_idToNFT[i + 1].owner == msg.sender) {
        myNftCount++;
      }
    }

    NFT[] memory nfts = new NFT[](myNftCount);
    uint nftsIndex = 0;
    for (uint i = 0; i < nftCount; i++) {
      if (_idToNFT[i + 1].owner == msg.sender) {
        nfts[nftsIndex] = _idToNFT[i + 1];
        nftsIndex++;
      }
    }
    return nfts;
  }

  /// @dev this could be now broken down between listed for sale and listed for renting
  function getMyListedNfts() public view returns (NFT[] memory) {
    uint nftCount = _nftCount.current();
    uint myListedNftCount = 0;
    for (uint i = 0; i < nftCount; i++) {
      if (_idToNFT[i + 1].seller == msg.sender && _idToNFT[i + 1].listed) {
        myListedNftCount++;
      }
    }

    NFT[] memory nfts = new NFT[](myListedNftCount);

    uint nftsIndex = 0;
    for (uint i = 0; i < nftCount; i++) {
      if (_idToNFT[i + 1].seller == msg.sender && _idToNFT[i + 1].listed) {
        nfts[nftsIndex] = _idToNFT[i + 1];
        nftsIndex++;
      }
    }
    return nfts;
  }


  /// @dev we want to be able to update fees to reflect changes in circumstances
  function updateListingFee(uint256 _newPrice) public {
      require(msg.sender == _marketOwner, "You can't change the LISTING_FEE");
      LISTING_FEE = _newPrice;
  }

  function updateRentFee(uint256 _newPrice) public {
      require(msg.sender == _marketOwner, "You can't change the RENT_FEE");
      RENT_FEE = _newPrice;
  }

  function updateSaleFee(uint256 _newPrice) public {
      require(msg.sender == _marketOwner, "You can't change the SALE_FEE");
      SALE_FEE = _newPrice;
  }


  /// @dev we want to be able to withdraw fees
  function withdraw() public {
      uint256 amount = pendingWithdrawals[msg.sender];
      pendingWithdrawals[msg.sender] = 0;
      payable(msg.sender).transfer(amount);
  }

 
}
