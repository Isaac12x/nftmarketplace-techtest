# Development diary

### Tech test meta ###
09/07/2022 
17.45: Starting - Haven't read or done anything around it yet. 
19.45: Stop

10/07/2022 
10:15: Restart


### Disclaimer
This might be the correct approach, yet incomplete due to the time constraints.


### Assumptions
* Boilerplate
I'm assuming truffle can be used and also truffle boxes - using React Truffle
box to get started

* ERCs 
I'm assuming only final ERCs can be used given this is for a company
using the smart contracts in productions

* Blocking

### What
We want to achieve (final picture):
Ability to create NFTs -> an ERC721 contract
Ability to transfer these NFTs -> also defined in the ERC721 contract
Ability to interact with events when a new NFT is created in the website!

Ability to sell/buy the NFTs
Ability to list the NFTs in a marketplace
Ability to lease the NFTs for a period of time @ a certain cost (payable)
Ability to regain the NFT rights and monies once the timelock has passed

### Thinking


The building blocks for this project are an NFT (that goes to EIP-721, standard implementation)
with the methods buy, sell, rent, list.

The first smart contract will require
* certain properties that NFT needs to have: something like, name, game, buy price.
* a registry of created nfts

The above will require a place to register the addresses of all created NFTs


I started by reading:
    [EIP - 2309](https://eips.ethereum.org/EIPS/eip-2309)
    [EIP-2981](https://eips.ethereum.org/EIPS/eip-2981)
    [EIP-4907](https://eips.ethereum.org/EIPS/eip-4907)
    [EIP-4400](https://eips.ethereum.org/EIPS/eip-4400)
    


