# Development diary

### Tech test meta ###
09/07/2022 
17.45: Starting - Haven't read or done anything around it yet. 
19.45: Stop

10/07/2022 
10:15: Restart
12:30: Stop
16:00: Restart
17:45: Finish


### Disclaimer
This might be the correct approach, yet incomplete due to the time constraints.


### Assumptions
* Boilerplate 

I'm assuming truffle can be used and also truffle boxes - using
React Truffle box to get started

Also other people's code will be used to speed up the task.

* ERCs 

I'm assuming only final ERCs can be used given this is for a company
using the smart contracts in productions


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
The building blocks for this project are an NFT (that goes to EIP-721, standard
implementation) and a marketplace where to send the token for buying, selling,
renting and listing.

The first smart contract will require
* Properties that NFT needs to have: something id, price, game - basically the
  data and metadata of the NFT.
* A registry of created nfts.
* I've opted to adopt the most complete ERC721 implementation, where the token
  is pausable, burnable, etc. The biggest win with this however is the ability
  to test for interfaces that comes for free with that inheritance.

The second smart contract will require
* The ability to list, sell, relist and rent
* The ability to get the money from the smart contract (fees, and extra money
  sent.)

The above will require a place to register the addresses of all created NFTs.


I started by reading:
* [EIP-2309](https://eips.ethereum.org/EIPS/eip-2309)
* [EIP-2981](https://eips.ethereum.org/EIPS/eip-2981)
* [EIP-4907](https://eips.ethereum.org/EIPS/eip-4907)
* [EIP-4400](https://eips.ethereum.org/EIPS/eip-4400)
    
I haven't used all of them, despite some of them being very interesting for the
test.

### How it went
At first I made the NFT be deployed once the marketplace contract was deployed
so to have the address passed in to the constructor at deploy time (build).
However, since this is about having quite some freedom - listing the NFT
wherever you want I opted for decoupling these.

Also, started the implementation of reserved tokens for the owner, however this
will induce some more complexity and paused the development of that bit.

I'm also showing a bit of versatility in the inheritance, e.g. one contract I
made it Ownable and another not Ownable and dealt with permissions on function
in the function itself.

I've also created an abstract contract, etc.

Could have done a better job with more time but have been quite constrained over
the weekend. If you need something more polished let me know and can arrange
some more time during the week. Also, some time was lost in setting up for development that is also accounted for in the times listed on the beginning of this document.

* On the smart contracts side:
I would liked to have done testing for the contracts, due to the time limitation I only had time to work on the main functionality without much attention to anything else.

* On the react side:
I would have like to finish the implementation to interact with the contract on the react side.


