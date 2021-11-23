# Design patterns used

## Access Control Design Patterns

- `Ownable` design pattern used in the function: `withdraw()`, so that only contract creator can withdraw any funds from contract.

## Inheritance and Interfaces

- `NftTradingPlatform` contract inherits the OpenZeppelin `ERC721URIStorage` and `Ownable` contracts to enable token creations and ownership management.
