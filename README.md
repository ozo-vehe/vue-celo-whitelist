# Building a Whitelist Dapp On the Celo blockchain Using Vue.js
#### Estimated Time: 20 minutes
#### Demo Link: [Vue Celo Whiteliast DApp](https://vue-celo-whitelist.vercel.app/)

## Table of Content
- [Introduction](#introduction)
- [Requirements](#requirements)
- [Prerequisites](#prerequisites)
- Tech stack
- [Build and deploy the smart contract](#build-and-deploy-the-smart-contract)
- [Building the front end using Vue.js](#building-the-frontend-with-vue)
- [Pushing to Github](#pushing-code-to-github)
- [Deploying to Vercel](#deploying-to-vercel)


## Introduction
Welcome to this tutorial on building a Celo whitelist dapp using Vue.js! In this tutorial, we will walk you through the steps of building a decentralized application (dapp) on the Celo blockchain platform that allows users to add addresses to a whitelist. We will be using Vue.js as our front-end framework to build the user interface, and the Celo blockchain platform to store the whitelist data on the blockchain.

Before we dive into the technical details, let's briefly go over what a whitelist dapp is and why it might be useful. A whitelist dapp is a type of decentralized application that maintains a list of approved addresses that are allowed to perform certain actions on the blockchain, such as accessing a specific smart contract or executing a transaction. This can be useful for a variety of use cases, such as controlling access to a private smart contract, or ensuring that only authorized parties can participate in a specific token sale.

Throughout this tutorial, we will guide you through the process of building a basic Vue.js front end that interacts with a Celo smart contract on the blockchain. By the end of this tutorial, you will have a basic understanding of how to build a decentralized application using Vue.js and the Celo blockchain platform.

To build this dapp, we will be using the following technologies:

1.  [Vue.js](https://vuejs.org/): A popular JavaScript frontend framework for building user interfaces.
2.  [Celo](https://celo.org/): A blockchain platform that allows for fast and secure transactions and smart contracts. Celo was designed to enable a new universe of financial solutions accessible to mobile users, creating a global financial ecosystem where an end-user can onboard into the Celo ecosystem with just a mobile number. It offers the following key features
  - Layer-1 protocol
  - EVM compatible
  - Proof-of-stake
  - Carbon negative
  - Mobile-first identity
  - Ultra-light clients
  - Localized stablecoins (cUSD, cEUR, cREAL)
  - Gas payable in multiple currencies
  For more information, click [here](https://docs.celo.org/general) to learn more about Celo
3.  [Solidity](https://soliditylang.org/): A programming language used to write smart contracts on the Ethereum and Celo blockchain platforms.

## Requirements
- Writing the smart contract and deploying it on the Celo blockchain using the Remix IDE. Access should be given to the first 15 users for free who want to get in.
- There should be a website where people can go and enter into the whitelist. We will use Vue.js to build it and interact with our smart contract

## Prerequisites
- You can write code in Vue.js
- Have the Celo Extension Wallet installed and set up. If not, install [CeloExtensionWallet](https://chrome.google.com/webstore/detail/celoextensionwallet/kkilomkmpmkbdnfelcpgckmpcaemjcdh?hl=en) from the Google Chrome store
- [Node.js](https://nodejs.org/en/) installed on your machine.
- An IDE such as [VSCode](https://code.visualstudio.com/) or [Sublime Text](https://www.sublimetext.com/).
- [Remix IDE](https://remix.ethereum.org/).
- Command line or similar software installed.

Let's start building 🚀


## Build And Deploy The Smart Contract
Now it's time to create a Solidity smart contract.
You can use any editor you like to make the contract. However, for this part of the tutorial we recommend using the [RemixIDE](https://remix.ethereum.org/)
#### 1.  Go to Remix
![Remix IDE](https://github.com/ozo-vehe/vue-celo-whitelist/blob/master/remixIDE.png)

#### 2.  Create a new Solidity file in the contract folder of remixIDE and name it `Whitelist.sol`

#### 3.  Copy and paste the follwing code into the new Solidity file created

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

#### 4.  Deploying the smart contract on the Celo blockchain
Create a Celo wallet and deploy your contract to the Celo testnet Alfajores.
If you don't have the Celo Extension Wallet installed, follow the prompt below to install and set up your celo extension wallet

#### 4.1. Install the [CeloExtensionWallet](https://chrome.google.com/webstore/detail/celoextensionwallet/kkilomkmpmkbdnfelcpgckmpcaemjcdh?hl=en) from the Google Chrome Store.
![](https://raw.githubusercontent.com/dacadeorg/celo-development-101/main/content/gifs/celo_install_celo_extension_wallet.gif)

#### 4.2. Create a wallet.
![](https://raw.githubusercontent.com/dacadeorg/celo-development-101/main/content/gifs/celo_create_wallet.gif)

#### 4.3. Get Celo token for the Alfajores testnet from [https://celo.org/developers/faucet](https://celo.org/developers/faucet)
![](https://raw.githubusercontent.com/dacadeorg/celo-development-101/main/content/gifs/celo_get_token_from_faucet.gif)

#### 4.4. Install the Celo Remix plugin and deploy your contract.
In this tutorial, we will be deploying our smart contract, `Whitelist.sol` as opposed to `Marketplace.sol` shown in below


![](https://raw.githubusercontent.com/dacadeorg/celo-development-101/main/content/gifs/celo_install_remix_plugin_and_deploy_contract.gif)
  
Great! You deployed your first contract on the Celo blockchain. Congratulations 🎉.

#### 5.  Saving the smart contract abi and address
When you compile your contract in Remix, Remix also creates the ABI in the form of a JSON for your contract. Copy the JSON and save it.

![](https://github.com/ozo-vehe/vue-celo-whitelist/blob/master/tutorial_assets/contract_abi.png)


It also creates an address of the contract which you need in order to find your contract and interact with it. Copy the address and save it.

![](https://github.com/ozo-vehe/vue-celo-whitelist/blob/master/tutorial_assets/contract_address.png)


In the next tutorial, you will learn how to create a front-end that will make use of your contract.


## Building The Frontend With Vue
To develop the website we will be using Vue, a javascript framework used to build interactive websites. It offers the following;
- Approachable: it builds on top of standard HTML, CSS and JavaScript with intuitive API and world-class documentation.
- Performant: truly reactive, compiler-optimized rendering system that rarely requires manual optimization.
- Versatile: a rich, incrementally adoptable ecosystem that scales between a library and a full-featured framework.

#### 1.  To start with, we will use Vite, the official Vue project scaffolding tool. 
Make sure you have an up-to-date version of Node.js installed, then run the following command in your command line terminal

```sh
npm create vite@latest vue-celo-whitelist -- --template vue
```
#### 2.  Navigate to the the project.

```sh
cd vue-celo-whitelist
```

#### 3.  Install the required dependencies.
```sh
npm install
```

#### 4.  Open the project in VS Code
```sh
code .
```

#### 5.  Start up a local development server. Using the command line or the terminal in VS Code.
```sh
npm run dev
```

The project directory should look something like this

![](https://github.com/ozo-vehe/vue-celo-whitelist/blob/master/tutorial_assets/project_setup.png)


#### 6.  In the `src` folder, delete the `components` folder(as the App.vue file will be sufficient for this tutorial) and the `vue.svg` file in the `assets` folder. Replace this file with this image [whitelist.png](https://github.com/ozo-vehe/vue-celo-whitelist/blob/master/tutorial_images/whitelist.png).

#### 7.  Create a new file called `contract.js` in the src folder and paste in the following code

```js
export const contractAbi = YOUR_CONTRACT_ABI;
export const contractAddress = "YOUR_CONTRACT_ADDRESS";
```

Replace YOUR_CONTRACT_ABI with the ABI of your Whitelist Contract and YOUR_CONTRACT_ADDRESS with the address of the whitelist contract that you deployed. All this was saved earlier during the tutorial

#### 8.  In the `App.vue` file, replace the code with the following code

```vue
<script setup>
  import { ref, reactive } from "vue";

  // DATA/VARIABLES
  const isConnected = ref(false); // variable for holding the state of a wallet, if its connected or not
  const walletLoading = ref(false); // variable to show or hide spinner animation for connwct wallet button
  const accessLoading = ref(false); // variable to show or hide spinner animation for get access button
  const isWhitelisted = ref(false); // checks if an address has already been whitelisted or not

</script>

<template>
  <main>
    <nav>
      <button v-if="isConnected" disabled>Wallet Connected</button>
      <button v-else>
        <span v-if="walletLoading" class="loader"></span>
        <span v-else>Connect Wallet</span>
      </button>
      <p v-if="isConnected">0.00 <span>cUSD</span></p>
      <p v-else>0.00 <span>cUSD</span></p>
    </nav>

    <div class="whitelist">
      <div class="whitelistHeader">
        <h1>Welcome to <span>WhiteListedChain</span></h1>
        <p>
          Secure, transparent access to decentralized networks. 
          Click the button below to get early access.
        </p>
        <div>
          <p>0 have already joined the Whitelist</p>
          <p v-if="isWhitelisted" class="whitelisted">Thanks for joining the WhiteListedChain's whitelist</p>
          <button v-else>
            <span v-if="accessLoading" class="loader"></span>
            <span v-else>Get Early Access Pass</span>
          </button>
        </div>
      </div>

      <div class="whitelistImage">
        <img src="./assets/whitelist.png" />
      </div>
    </div>
  </main>
</template>

<style scoped>
  @import url('https://fonts.googleapis.com/css2?family=Montserrat&display=swap');
  main {
    font-family: 'Montserrat';
    font-size: 16px;
    background-color: #fff;
  }
  nav {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 10px 5%;
  }
  button {
    display: flex;
    align-items: center;
    justify-content: center;
    border: none;
    min-width: 150px;
    height: 45px;
    overflow: hidden;
    background-color: #e096e0;
    color: #fff;
    padding: 13px 30px;
    border-radius: 8px;
    font-size: 1rem;
    cursor: pointer;
  }
  button:disabled {
    cursor: default;
    background-color: #e096e085;
  }
  button .loader {
    display: inline-block;
    border: thin solid #e096e0;
    width: 15px;
    height: 15px;
    border-radius: 50%;
    border-left: 2px solid #fff;
    animation: spinner 0.3s linear infinite;
  }
  @keyframes spinner {
    from { transform: rotate(0deg);}
    to { transform: rotate(360deg);}
  }

  .whitelist {
    display: flex;
    min-height: calc(100vh - 130px);
    justify-content: center;
    gap: 10px 30px;
    align-items: center;
    padding: 10px 5%;
  }
  .whitelist h1 {
    font-size: 4rem;
  }
  .whitelist h1 span {
    color: #e096e0;
  }

  .whitelist .whitelistHeader {
    width: 600px;
  }

  .whitelisted {
    color: #e096e0;
  }

  .whitelist .whitelistImage {
    width: 400px;
    height: 300px;
  }
  .whitelistImage img {
    width: 100%;
    height: 100%;
    object-fit: contain;
  }
</style>

```

#### 9.  Go to the `style.css` file in the `src` folder and replace the code with the following
```css
body {
  margin: 0px;
  padding: 0px;
  box-sizing: border-box;
}
```


Your project should look like this

![](https://github.com/ozo-vehe/vue-celo-whitelist/blob/master/tutorial_assets/image1.png)


#### 10.  We will now install a few packages needed to interact with our smart contract deployed on the Celo blockchain. Run the following command on the terminal

```sh
npm install web3 @celo/contractkit
```
```sh
npm install vite-plugin-node-polyfills
```

After installing these packages, open `vite.config.js` file in the root directory and replace the code with the following code

```js
  import { defineConfig } from 'vite';
  import vue from '@vitejs/plugin-vue';
  import { nodePolyfills } from 'vite-plugin-node-polyfills';

  // https://vitejs.dev/config/
  export default defineConfig({
    plugins: [
      vue(),
      nodePolyfills({
        protocolImports: true,
      })
    ]
  })
  
```

#### 11. In the `App.vue` file, import the packages installed and add the following variables as they will be need for this tutorial

```vue
<script setup>
  import { ref, reactive } from "vue";
  
  import Web3 from "web3";
  import { newKitFromWeb3 } from "@celo/contractkit";
  import { contractAbi, contractAddress } from './contract';
  
  ...
  
  const ERC20_DECIMALS = 18;  // for balance conversion to a readable amount
  let kit = reactive(null);
  let cUSDBalance = ref(null);  // for holding the user's cUSD balance
  const numberOfWhitelistedAddresses = ref(0);  //  For storing the number of whitelisted addresses
  let contract = reactive(null);  //  to store a contract instance

</script>

```


#### 12. We will now write three functions, one to connect to the Celo Extension Wallet, one to get the user's balance in cUSD and the last function to add a user to the whitelist.

##### 12.1. To connect to the Celo Extension Wallet, we will create the `connectWallet()` function

```vue

<script setup>
  ...
 
  // Connect to the cele extension wallet
  const connectWallet = async() => {
    // Check if celo extension is installed else, user is prompted to install the extension
    if(window.celo) {
      try {
        walletLoading.value = true;

        // Enable the celo extension to connect to an account created
        await window.celo.enable()
        
        // Using Web3 imported, create a new web3 instance passing in the window.celo as the provider
        const web3 = new Web3(window.celo)
        
        // assign the web3 instance to the variable kit using newKitFromWeb3 and passing the instance as an argument
        kit = newKitFromWeb3(web3);

        // get the connected address 
        const accounts = await kit.web3.eth.getAccounts()
        
        // assign the connected address to kit.deafulAccount
        kit.defaultAccount = accounts[0];

        // Call the getBalance function to get the users cUSD balance
        await getBalance();

        // Set isConnected to true and loading to false
        isConnected.value = true;
        walletLoading.value = false;

        // Create a new contract instance using the contract info saved in contract.js file(contractAbi and contractAddress) and assing it to the reactive contract variable created earlier
        contract = new kit.web3.eth.Contract(contractAbi, contractAddress)

        // Get the number of whitelisted addresses and assign it to the numberOfWhiteListedAddresses ref variable
        numberOfWhitelistedAddresses.value =  await contract.methods.numAddressesWhitelisted().call();
        
        // Check if the connect account address has been whitelisted or not and assign it to the isWhitelisted ref variable
        isWhitelisted.value = await contract.methods.whitelistedAddresses(kit.defaultAccount).call();
      } catch (error) {
        console.log(error)
      }
    } else {
      alert("Celo Extension Walltet Not Installed");
    }
  }

</script>
```

#### 12.2.  To get a user's balance in cUSD, we will create the `getBalance()` function

```vue
<script setup>
  ...
  
  // Get user balance in cUSD
  const getBalance = async() => {
    // Using the getTotalBalance function from kit, get the total balance and assign it to a totalBalance variable
    const totalBalance = await kit.getTotalBalance(kit.defaultAccount)
    
    // Using the ERC20_DECIMAL constant, convert the total balance to a readable amount set to 2 decimal places
    // assign the value to the cUSDBalance ref created earlier 
    cUSDBalance.value = totalBalance.cUSD.shiftedBy(-ERC20_DECIMALS).toFixed(2)
  }

</script>
```

#### 12.3.  To add a user's address to the whitelist, we will create the `joinWhitelist()` function

```vue
<script setup>

  ...
  
  // Add an account to the whitelist
  const joinWhitelist = async() => {
    // Change the accessLoading ref variable to false to stop the loaing animation
    accessLoading.value = true;    
        
    // Checks if a wallet is connected, if not, alerts users to connect their wallet (the celo extension wallet)
    if(isConnected.value) {
      try {
        // Create a new contract instance with the HelloWorld contract info
        await contract.methods.addAddressToWhitelist().send({ from: kit.defaultAccount })
    
        // Get the number of whitelisted addresses and assign it to the numberOfWhitelistedAddresses ref variable
        numberOfWhitelistedAddresses.value =  await contract.methods.numAddressesWhitelisted().call();
        
        // Change the is whitlisted ref variable to true for this address
        isWhitelisted.value = true;
        
        // Change the accessLoading ref variable to false to stop the loaing animation
        accessLoading.value = false;
      } catch(error) {
        alert(error);
      }
    }
    else {
      alert("Connect Wallet (A Celo Extension Wallet)");
    }
  }
</script>
```

The final code for the `App.vue` file should look like this with the final changes made by replacing hard coded values with their respective

```vue
<script setup>
  import { ref, reactive } from "vue";
  import Web3 from "web3";
  import { newKitFromWeb3 } from "@celo/contractkit";
  import { contractAbi, contractAddress } from './contract';

  // DATA/VARIABLES
  const isConnected = ref(false); // variable for holding the state of a wallet, if its connected or not
  const walletLoading = ref(false); // variable to show or hide spinner animation for connwct wallet button
  const accessLoading = ref(false); // variable to show or hide spinner animation for get access button
  const isWhitelisted = ref(false); // checks if an address has already been whitelisted or not
  
  const ERC20_DECIMALS = 18;  // for balance conversion to a readable amount
  let kit = reactive(null);
  let cUSDBalance = ref(null);  // for holding the user's cUSD balance
  const numberOfWhitelistedAddresses = ref(0);  //  For storing the number of whitelisted addresses
  let contract = reactive(null);  //  to store a contract instance


  // METHODS/FUNCTIONS

  // Get user balance in cUSD
  const getBalance = async() => {
    // Using the getTotalBalance function from kit, get the total balance and assign it to a totalBalance variable
    const totalBalance = await kit.getTotalBalance(kit.defaultAccount)
    
    // Using the ERC20_DECIMAL constant, convert the total balance to a readable amount set to 2 decimal places
    // assign the value to the cUSDBalance ref created earlier 
    cUSDBalance.value = totalBalance.cUSD.shiftedBy(-ERC20_DECIMALS).toFixed(2)
  }

  // Connect to the cele extension wallet
  const connectWallet = async() => {
    // Check if celo extension is installed else, user is prompted to install the extension
    if(window.celo) {
      try {
        walletLoading.value = true;

        // Enable the celo extension to connect to an account created
        await window.celo.enable()
        
        // Using Web3 imported, create a new web3 instance passing in the window.celo as the provider
        const web3 = new Web3(window.celo)
        
        // assign the web3 instance to the variable kit using newKitFromWeb3 and passing the instance as an argument
        kit = newKitFromWeb3(web3);

        // get the connected address 
        const accounts = await kit.web3.eth.getAccounts()
        
        // assign the connected address to kit.deafulAccount
        kit.defaultAccount = accounts[0];

        // Call the getBalance function to get the users cUSD balance
        await getBalance();

        // Set isConnected to true and loading to false
        isConnected.value = true;
        walletLoading.value = false;

        // Create a new contract instance using the contract info saved in contract.js file(contractAbi and contractAddress) and assing it to the reactive contract variable created earlier
        contract = new kit.web3.eth.Contract(contractAbi, contractAddress)

        // Get the number of whitelisted addresses and assign it to the numberOfWhiteListedAddresses ref variable
        numberOfWhitelistedAddresses.value =  await contract.methods.numAddressesWhitelisted().call();
        
        // Check if the connect account address has been whitelisted or not and assign it to the isWhitelisted ref variable
        isWhitelisted.value = await contract.methods.whitelistedAddresses(kit.defaultAccount).call();
      } catch (error) {
        console.log(error)
      }
    } else {
      alert("Celo Extension Walltet Not Installed");
    }
  }
  
  // Add an account to the whitelist
  const joinWhitelist = async() => {
    // Change the accessLoading ref variable to false to stop the loaing animation
    accessLoading.value = true;    
        
    // Checks if a wallet is connected, if not, alerts users to connect their wallet (the celo extension wallet)
    if(isConnected.value) {
      try {
        // Create a new contract instance with the HelloWorld contract info
        await contract.methods.addAddressToWhitelist().send({ from: kit.defaultAccount })
    
        // Get the number of whitelisted addresses and assign it to the numberOfWhitelistedAddresses ref variable
        numberOfWhitelistedAddresses.value =  await contract.methods.numAddressesWhitelisted().call();
        
        // Change the is whitlisted ref variable to true for this address
        isWhitelisted.value = true;
        
        // Change the accessLoading ref variable to false to stop the loaing animation
        accessLoading.value = false;
      } catch(error) {
        alert(error);
      }
    }
    else {
      alert("Connect Wallet (A Celo Extension Wallet)");
    }
  }
</script>

<template>
  <main>
    <nav>
      <button v-if="isConnected" disabled>Wallet Connected</button>
      <button v-else @click="connectWallet">
        <span v-if="walletLoading" class="loader"></span>
        <span v-else>Connect Wallet</span>
      </button>
      <p v-if="isConnected">{{ cUSDBalance }} <span>cUSD</span></p>
      <p v-else>0.00 <span>cUSD</span></p>
    </nav>

    <div class="whitelist">
      <div class="whitelistHeader">
        <h1>Welcome to <span>WhiteListedChain</span></h1>
        <p>
          Secure, transparent access to decentralized networks. 
          Click the button below to get early access.
        </p>
        <div>
          <p>{{ numberOfWhitelistedAddresses }} have already joined the Whitelist</p>
          <p v-if="isWhitelisted" class="whitelisted">Thanks for joining the WhiteListedChain's whitelist</p>
          <button v-else @click="joinWhitelist">
            <span v-if="accessLoading" class="loader"></span>
            <span v-else>Get Early Access Pass</span>
          </button>
        </div>
      </div>

      <div class="whitelistImage">
        <img src="./assets/whitelist.png" />
      </div>
    </div>
  </main>
</template>

<style scoped>
  @import url('https://fonts.googleapis.com/css2?family=Montserrat&display=swap');
  main {
    font-family: 'Montserrat';
    font-size: 16px;
    background-color: #fff;
  }
  nav {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 10px 5%;
  }
  button {
    display: flex;
    align-items: center;
    justify-content: center;
    border: none;
    min-width: 150px;
    height: 45px;
    overflow: hidden;
    background-color: #e096e0;
    color: #fff;
    padding: 13px 30px;
    border-radius: 8px;
    font-size: 1rem;
    cursor: pointer;
  }
  button:disabled {
    cursor: default;
    background-color: #e096e085;
  }
  button .loader {
    display: inline-block;
    border: thin solid #e096e0;
    width: 15px;
    height: 15px;
    border-radius: 50%;
    border-left: 2px solid #fff;
    animation: spinner 0.3s linear infinite;
  }
  @keyframes spinner {
    from { transform: rotate(0deg);}
    to { transform: rotate(360deg);}
  }

  .whitelist {
    display: flex;
    min-height: calc(100vh - 130px);
    justify-content: center;
    gap: 10px 30px;
    align-items: center;
    padding: 10px 5%;
  }
  .whitelist h1 {
    font-size: 4rem;
  }
  .whitelist h1 span {
    color: #e096e0;
  }

  .whitelist .whitelistHeader {
    width: 600px;
  }

  .whitelisted {
    color: #e096e0;
  }

  .whitelist .whitelistImage {
    width: 400px;
    height: 300px;
  }
  .whitelistImage img {
    width: 100%;
    height: 100%;
    object-fit: contain;
  }
</style>

```



## Pushing Code To Github
After testing your dapp and checking that everything behaves correctly, upload your project to a new GitHub repository. For more information on how to push your code to Github, read this article ["push to GitHub"](https://www.git-tower.com/learn/git/faq/push-to-github/).

If needed, you can create a readme file for your project that explains your dapp and includes a link to your dapp.


## Deploying To Vercel
We will now deploy your dapp so that everyone can see your website and you can share it with everyone.

Follow these steps to deploy your dapp to [Vercel](https://vercel.com/)
1.  Go to Vercel and sign in with your GitHub.
2.  Then click on Add New button, select Project from the dropdown menu, and then select your Whitelist dapp repo from the options given.
3.  When configuring your new project, Vercel will allow you to customize your Root Directory. However, for this project, we will leave it at the Root Directory
4.  Select the Framework as Vite
5.  Click Deploy

Now you can see your deployed website by going to your dashboard, selecting your project, and copying the URL beneath domains!

That’s it! Congratulations! You are done with the tutorial and have built a dapp using Vue and Solidity, pushed your code to Github, and deployed it to Vercel! 🎉
