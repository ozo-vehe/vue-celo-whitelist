# BUILDING A CELO WHITELIST DAPP USING VUE.JS
A whitelist dapp built on the celo blockchain using Vue.js for giving users early access to any services(could be early access to an NFT collection, a marketplace etc).


## Table of Content
- Introduction
- Requirement
- Prerequisites
- Tech stack
- Build and deploy the smart contract
- Building the frontend using Vue.js
- Pushing to Github
- Delpoying to vercel


## Introduction
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


## Requirements
- Writing the smart contract and deploying it on the celo blockchain using RemixIDE. Access should be given to the first 15 users for free who want to get in.
- There should be a website where people can go and enter into the whitelist. We will use Vue.js to build it and interact with our smart contract

## Prerequisites
- You can write code in Vue.js
- Have celo extension wallet installed and set up. If not, install [CeloExtensionWallet](https://chrome.google.com/webstore/detail/celoextensionwallet/kkilomkmpmkbdnfelcpgckmpcaemjcdh?hl=en) from Google Chrome store
- Nodejs installed on your machine.
- An IDE such as Vscode or Sublime text.
- Remix IDE.
- Command line or similar software installed.

Lets start building 🚀


## Build And Deploy The Smart Contract
Now it's time to create a Solidity smart contract.
You can use any editor you like to make the contract. However, for this part of the tutorial we recommend the online IDE [RemixIDE](https://remix.ethereum.org/)
### 1.  Go to Remix
![Remix IDE](https://github.com/ozo-vehe/vue-celo-whitelist/blob/master/remixIDE.png)

### 2.  Create a new solidity file in the contract folder of remixIDE, named Whitelist.sol

### 3.  Copy and paste the follwing code into the new solidity file created

#### 3.1 Specify the solidity version and add a license 
```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;
```

#### 3.2 Define the contract
```solidity
contract Whitelist {
  // This is the contract's body, here you'll specify the logic for this contract.
}
```

#### 3.3 Inside the contract create the following variables
```solidity
// Max number of whitelisted addresses allowed to join the whitelist
uint256 public maxWhitelistedAddresses = 10;

// Create a mapping of whitelistedAddresses
// if an address is whitelisted, we would set it to true, it is false by default for all other addresses.
mapping(address => bool) public whitelistedAddresses;

// numAddressesWhitelisted would be used to keep track of how many addresses have been whitelisted
uint256 public numAddressesWhitelisted;
```

#### 3.4 Next, create the addAddressToWhitelist function
```solidity
/**
addAddressToWhitelist - This function adds the address of the sender to the whitelist
*/
function addAddressToWhitelist() public {
  // check if the user has already been whitelisted
  require(!whitelistedAddresses[msg.sender], "Sender has already been whitelisted");
 
  // check if the numAddressesWhitelisted < maxWhitelistedAddresses, if not then throw an error.
  require(numAddressesWhitelisted < maxWhitelistedAddresses, "More addresses cant be added, limit reached");
 
  // Add the address which called the function to the whitelistedAddress array
  whitelistedAddresses[msg.sender] = true;
 
  // Increase the number of whitelisted addresses
  numAddressesWhitelisted += 1;
}
```

#### 3.5 The final file should look like this
```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

contract Whitelist {
  // This is the contract's body, here you'll specify the logic for this contract.
  // Max number of whitelisted addresses allowed to join the whitelist
  uint256 public maxWhitelistedAddresses = 10;

  // Create a mapping of whitelistedAddresses
  // if an address is whitelisted, we would set it to true, it is false by default for all other addresses.
  mapping(address => bool) public whitelistedAddresses;

  // numAddressesWhitelisted would be used to keep track of how many addresses have been whitelisted
  uint256 public numAddressesWhitelisted;
  
  /**
  addAddressToWhitelist - This function adds the address of the sender to the whitelist
  */
  function addAddressToWhitelist() public {
    // check if the user has already been whitelisted
    require(!whitelistedAddresses[msg.sender], "Sender has already been whitelisted");
 
    // check if the numAddressesWhitelisted < maxWhitelistedAddresses, if not then throw an error.
    require(numAddressesWhitelisted < maxWhitelistedAddresses, "More addresses cant be added, limit reached");
 
    // Add the address which called the function to the whitelistedAddress array
    whitelistedAddresses[msg.sender] = true;
 
    // Increase the number of whitelisted addresses
    numAddressesWhitelisted += 1;
  }
}
```

### 4.  Deploying the smart contract on the celo blockchain
Create a Celo wallet and deploy your contract to the Celo testnet alfajores.
If you don't have celo extension wallet installed, follow the prompt below to install and set up your celo extension wallet

#### 4.1. Install the [CeloExtensionWallet](https://chrome.google.com/webstore/detail/celoextensionwallet/kkilomkmpmkbdnfelcpgckmpcaemjcdh?hl=en) from the Google Chrome Store.
![](https://raw.githubusercontent.com/dacadeorg/celo-development-101/main/content/gifs/celo_install_celo_extension_wallet.gif)

#### 4.2. Create a wallet.
![](https://raw.githubusercontent.com/dacadeorg/celo-development-101/main/content/gifs/celo_create_wallet.gif)

#### 4.3. Get Celo token for the alfajores testnet from [https://celo.org/developers/faucet](https://celo.org/developers/faucet)
![](https://raw.githubusercontent.com/dacadeorg/celo-development-101/main/content/gifs/celo_get_token_from_faucet.gif)

#### 4.4. Install the Celo remix plugin and deploy your contract.
In this tutorial, we will be deploy our smart contract, Whitelist.sol as opposed to Marketplace.sol shown in below


![](https://raw.githubusercontent.com/dacadeorg/celo-development-101/main/content/gifs/celo_install_remix_plugin_and_deploy_contract.gif)
  
Great! You deployed your first contract on the Celo blockchain. Congratulations 🎉.

In the next tutorial, you will learn how to create a front-end that will make use of your contract.


## Building The Frontend With Vue
To develop the website we will be using Vue. Vue is a javascript framework used to make websites and has the following advantages
- Approachable: it builds on top of standard HTML, CSS and JavaScript with intuitive API and world-class documentation.
- Performant: truly reactive, compiler-optimized rendering system that rarely requires manual optimization.
- Versatile: a rich, incrementally adoptable ecosystem that scales between a library and a full-featured framework.
To start with we will use vite which is the official Vue project scaffolding tool. Make sure you have an up-to-date version of Node.js installed, then run the following command in your command line terminal

```
npm init vue@latest
```
