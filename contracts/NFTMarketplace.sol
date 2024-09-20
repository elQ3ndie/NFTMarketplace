// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract NFTMarketplace is ERC721URIStorage, Ownable {
    uint256 tokenIds;

    mapping(uint256 => uint256) salePrices; //tokenID => Saleprice

    constructor(
        address initialOwner,
        string memory name,
        string memory symbol
    ) ERC721(name, symbol) Ownable(initialOwner) {}

    function mintNFT(
        address recipient,
        string memory tokenURI
    ) public onlyOwner returns (uint256) {
        tokenIds++;

        uint256 newItemId = tokenIds;
        _mint(recipient, newItemId);
        _setTokenURI(newItemId, tokenURI);

        return newItemId;
    }

    function sellNFT(uint _tokenId, uint256 salePrice) external {
        require(ownerOf(_tokenId) == msg.sender, "You're not the owner");
        require(_tokenId > 0, "Token Id must be greater than zero");
        require(_tokenId < tokenIds, "Invalid token Id");
        require(salePrice > 0, "Sale price must be greater than zero");

        salePrices[_tokenId] = salePrice;
    }

    function buyNFT(uint256 _tokenId) external payable {
        uint256 salePrice = salePrices[_tokenId];

        require(salePrice > 0, "This NFT is not for sale");
        require(msg.value >= salePrice, "Insufficient funds");

        address seller = ownerOf(_tokenId);

        // Transfer the NFT
        _safeTransfer(seller, msg.sender, _tokenId, "");

        // Transfer the funds to the seller
        (bool success, ) = seller.call{value: msg.value}("");
        require(success, "Transaction failed");

        salePrices[_tokenId] = 0;
    }

    function transferNFT(address to, uint256 _tokenId) external {
        require(ownerOf(_tokenId) == msg.sender, "You're not the owner");
        require(_tokenId > 0, "Token Id must be greater than zero");
        require(_tokenId < tokenIds, "Invalid token Id");

        // Perform the transfer
        _safeTransfer(msg.sender, to, _tokenId, "");
    }
}
