// SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MyNFT is ERC1155, Ownable {
    uint256 private _currentTokenId = 0;
    uint8 public constant NUM_TRAITS = 8;

    constructor(string memory uri) ERC1155(uri) {}

    function mint(
        address account,
        uint8 trait,
        uint256 amount
    ) public onlyOwner {
        require(trait < NUM_TRAITS, "Invalid trait");

        _mint(account, _currentTokenId + trait, amount, "");
    }

    function setURI(string memory newuri) public onlyOwner {
        _setURI(newuri);
    }
}

