// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/// @title Contract for trading NFTs
/// @author Hao Hao
/// @notice Allows users to create/buy/sell NFTs
/// @dev Contract inherited from ERC721 token.
contract NftTradingPlatform is ERC721URIStorage, Ownable {

    /// @notice Emitted when a token is created
    /// @param tokenId Token id
    /// @param uri Token URI
    event TokenCreated(uint256 tokenId, string uri);

    /// @notice Emitted when a token is bought
    /// @param seller The seller for the token
    /// @param buyer The buyer for the token
    /// @param price Token price
    event NftBought(address seller, address buyer, uint256 price);

    struct Item {
        uint id;
        uint price;
        address payable owner;
    }

    /// @dev Array list to capture all items for display listings
    Item[] items;

    /// @dev Map for storing all listed tokens.
    mapping (uint => Item) internal itemMap;

    /// @dev The default token price.
    uint256 defaultTokenPrice = 5;

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    /// @notice Check if the token to the given id exists
    /// @param tokenId Token id
    modifier tokenExists(uint256 tokenId) {
        require(itemMap[tokenId].id > 0, 'Token not found');
        _;
    }

    constructor() ERC721("NFT Trading Platform", "NFTTP") {
    }

    /// @notice Create a token with the given URI
    /// @param tokenURI The token URI
    /// @dev Emit TokenCreated event
    function createToken(string memory tokenURI) public {
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current() + 10000;

        _mint(msg.sender, newItemId);
        _setTokenURI(newItemId, tokenURI);

        Item memory newItem = Item({
            id: newItemId,
            price: defaultTokenPrice,
            owner: payable(msg.sender)
        });
        items.push(newItem);
        itemMap[newItemId] = newItem;

        emit TokenCreated(newItemId, tokenURI);
    }

    /// @notice Update the token listing with given price
    /// @param tokenId The token id
    /// @param price The token price
    /// @dev Check if the token exists first
    function setTokenPrice(uint256 tokenId, uint256 price) public tokenExists(tokenId) {
        require(msg.sender == ownerOf(tokenId), 'Only owner can set the price');

        //both array and map needs to be updated
        itemMap[tokenId].price = price;
        for (uint i=0; i<items.length; ++i) {
            if(items[i].id == tokenId) {
                items[i].price = price;
            }
        }
    }

    /// @notice Get the token price with given id
    /// @param tokenId The token id
    /// @dev Check if the token exists first
    function getTokenPrice(uint256 tokenId) public view tokenExists(tokenId) returns(uint256) {
        return itemMap[tokenId].price;
    }

    /// @notice Get all listed tokens
    function getItems() public view returns (Item[] memory) {
        return items;
    }

    /// @notice Allow buying token from other user to a given token id with expected price paid
    /// @param tokenId Token to which the sender address is purchasing
    /// @dev Check for if enough payment is made
    function buy(uint256 tokenId) external payable {
        // use storage to indicate reference instead of copy by value
        Item storage curItem = itemMap[tokenId];
        uint price = curItem.price;
        address payable curOwner = curItem.owner;

        require(msg.value >= price, 'Not enough for price');

        (bool sent, ) = curOwner.call{ value: msg.value }("");
        require(sent, "Failed to send");

        _transfer(curOwner, msg.sender, tokenId);
        address payable newOwner = payable(msg.sender);
        curItem.owner = newOwner;
        for (uint i=0; i<items.length; ++i) {
            if(items[i].id == tokenId) {
                items[i].owner = newOwner;
            }
        }

        emit NftBought(curOwner, msg.sender, msg.value);
    }

    /// @notice Withdraw contract funds
    /// @dev Only the contract owner can call this
    function withdraw() public onlyOwner {
        // TODO: withdraw any funds from contract
    }
}