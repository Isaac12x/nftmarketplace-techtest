///const SimpleStorage = artifacts.require("SimpleStorage");
const NFT = artifacts.require("")
const NFTMarketplace = artifacts.require("")


/// Orchestrated deployment
module.exports =  async function(deployer) {
    await deployer.deploy(NFTMarketplace);
    const marketplace  = await NFTMarketplace.deployed();
    await deployer.deploy(NFT, marketplace.address);
    
};
