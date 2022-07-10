const NFT = artifacts.require("NFTWrapper");
const NFTMarketplace = artifacts.require("FuncMarketplace");


/// Orchestrated deployment
module.exports =  async function(deployer) {
    await deployer.deploy(NFT, "PokemnNFT", "POKEGO");
    await deployer.deploy(NFTMarketplace);

    // This shows how I wanted to deploy it in the beginning when
    // I wanted to make the marketplace only for this specific NFT
    // but opted otherwise later on.
    // const marketplace  = await NFTMarketplace.deployed();
    // await deployer.deploy(NFT, marketplace.address);
};
