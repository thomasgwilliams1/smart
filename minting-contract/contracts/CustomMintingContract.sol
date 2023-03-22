// SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./MyNFT.sol"; // Import the MyNFT contract

contract CustomMintingContract is Ownable {
    MyNFT public requiredNFT; // Change the type from IERC1155 to MyNFT
    IERC721 public freeMintNFT;
    uint256 public freeMintNFTTokenId;
    uint256 public mintStartTime;
    uint256 public mintEndTime;
    uint256 public discountedMintPrice = 0.05 ether;
    uint256 public regularMintPrice = 0.1 ether;

    mapping(address => bool) public discountList;

    event Minted(address indexed to, uint256 indexed tokenId, uint256 amount);

    constructor(
        address nftAddress,
        address freeMintNFTAddress,
        uint256 freeMintNFTTokenId,
        uint256 startTime,
        uint256 endTime
    ) {
        requiredNFT = MyNFT(nftAddress); // Change the typecast from IERC1155 to MyNFT
        freeMintNFT = IERC721(freeMintNFTAddress);
        freeMintNFTTokenId = freeMintNFTTokenId;
        mintStartTime = startTime;
        mintEndTime = endTime;
    }

    function addToDiscountList(address[] calldata accounts) external onlyOwner {
        for (uint256 i = 0; i < accounts.length; i++) {
            discountList[accounts[i]] = true;
        }
    }

    function removeFromDiscountList(address[] calldata accounts) external onlyOwner {
        for (uint256 i = 0; i < accounts.length; i++) {
            discountList[accounts[i]] = false;
        }
    }

    function mint(uint8 trait, uint256 amount) external payable {
        require(block.timestamp >= mintStartTime, "Minting has not started");
        require(block.timestamp <= mintEndTime, "Minting has ended");

        uint256 totalPrice;

        if (freeMintNFT.ownerOf(freeMintNFTTokenId) == msg.sender) {
            totalPrice = 0;
        } else if (discountList[msg.sender]) {
            totalPrice = discountedMintPrice * amount;
        } else {
            totalPrice = regularMintPrice * amount;
        }

        require(msg.value >= totalPrice, "Insufficient payment for minting");

        requiredNFT.mint(msg.sender, trait, amount);

        emit Minted(msg.sender, trait, amount);
    }
}
