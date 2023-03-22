const MyNFT = artifacts.require("MyNFT");
const CustomMintingContract = artifacts.require("CustomMintingContract");

module.exports = async function (deployer, network, accounts) {
    // The metadata URI for your ERC-1155 NFTs
    const uri = "https://yourmetadatauri.com/";

    // Deploy the MyNFT contract
    await deployer.deploy(MyNFT, uri);
    const myNFT = await MyNFT.deployed();

    // Replace the values below with your desired parameters
    const freeMintNFTAddress = "0x5946aeAAB44e65Eb370FFaa6a7EF2218Cff9b47D";
    const freeMintNFTTokenId = "1"
    const startTime = Math.floor(Date.now() / 1000); // The current timestamp
    const endTime = startTime + (72 * 60 * 60); // The timestamp for 72 hours later

    // Deploy the CustomMintingContract
    await deployer.deploy(
        CustomMintingContract,
        myNFT.address,
        freeMintNFTAddress,
        freeMintNFTTokenId,
        startTime,
        endTime
    );
    const customMintingContract = await CustomMintingContract.deployed();

    // Transfer the ownership of the MyNFT contract to the CustomMintingContract
    await myNFT.transferOwnership(customMintingContract.address);
};
