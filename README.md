# BUILDING A CELO WHITELIST DAPP USING VUE.JS
A whitelist dapp built on the celo blockchain using Vue.js for giving users early access to any services(could be early access to an NFT collection, a marketplace etc).


## Table of Content
- Introduction
- Requirement
- Prerequisites
- Tech stack
- Building the smart contract
- Building the frontend using Vue.js
- Pushing to Github
- Delpoying to vercel


### Introduction
Celo was designed to enable a new universe of financial solutions accessible for mobile users, creating a global financial ecosystem where an end-user can onboard into the Celo ecosystem with just a mobile number. It offers the following key features
- Layer-1 protocol
- EVM compatible
- Proof-of-stake
- Carbon negative
- Mobile-first identity
- Ultra-light clients
- Localized stablecoins (cUSD, cEUR, cREAL)
- Gas payable in multiple currencies
For more information, click [here](https://docs.celo.org/general) to learn more about celo


### Requirements
- Writing the smart contract and deploying it on the celo blockchain using RemixIDE. Access should be given to the first 15 users for free who want to get in.
- There should be a website where people can go and enter into the whitelist. We will use Vue.js to build it and interact with our smart contract

Lets start building 🚀

### Prerequisites
- You can write code in Vue.js
- Have celo extension wallet installed and set up. If not, install [CeloExtensionWallet](https://chrome.google.com/webstore/detail/celoextensionwallet/kkilomkmpmkbdnfelcpgckmpcaemjcdh?hl=en) from Google Chrome store
- Nodejs installed on your machine.
- An IDE such as Vscode or Sublime text.
- Remix IDE.
- Command line or similar software installed.

### Building The Smart Contract
Now it's time to create a Solidity smart contract.
You can use any editor you like to make the contract. However, for this part of the tutorial we recommend the online IDE [RemixIDE](https://remix.ethereum.org/)
1.  Go to Remix
2.  Check out the "Solidity Compiler", and "Deploy and Run Transactions" tabs. If they are not present, enable them in the plugin manager
3.  Create a new solidity file in remix, named mood.sol
4.  Write the contract

 

Specify the solidity version and add a license
```
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;
```
