# Final project - NFT Trading Platform

## Deployed version url:

https://haohao-co.github.io/project-client/

## How to run this project locally:

### Prerequisites

- Node.js >= v16
- Truffle
- `git checkout master`

### Contracts

- Run `npm install` in project root to install Truffle build and smart contract dependencies
- Run `truffle compile`
- Run `truffle develop`, in the Truffle console run `migrate`
- To run tests, in Truffle console: `test`

### Frontend

- `cd client`
- `npm install`
- Import accounts from local Truffle network with private keys shown in Truffle console to MetaMask
- `npm run start`
- Open `http://localhost:3000`

## Screencast link

https://youtu.be/L7oMb0dxVAk

## Public Ethereum wallet for certification:

`0x50b52737a12Bb6F799fC9F1475Bec8252D7c2f61`

## Project description

NFT trading platform offers a market place for users to create/buy/sell NFTs. In detail,
- User can create a NFT with given URI and list it for sell,
- Owner of the NFT can update the listed price,
- If any other uses are interested, they can buy it.
- Once the buyer pays the seller the listed price, the NFT will be transferred to the buyer.

## Directory structure

- `client`: Project's React frontend.
- `contracts`: Smart contracts that are deployed in the Rinkeby testnet.
- `migrations`: Migration files for deploying contracts in `contracts` directory.
- `test`: Tests for smart contracts.
