# BUILDING A WHITELIST DAPP ON THE CELO BLOCKCHAIN USING VUE.JS
- Estimated Time: 20 minutes
- Demo Link: [Vue Celo Whitelist DApp](https://vue-celo-whitelist.vercel.app/)

## Table of Content
- [Introduction](#Introduction)
- [Requirement](#requirements)
- [Prerequisites](#Prerequisites)
- [Build and deploy the smart contract](#build-and-deploy-the-smart-contract)
- [Building the frontend using Vue.js](#building-the-frontend-with-vue)
- [Pushing to Github](#pushing-code-to-github)
- [Delpoying to vercel](#deploying-to-vercel)


## Introduction
Welcome to this tutorial on building a Celo whitelist dapp using Vue.js! In this tutorial, we will walk you through the steps of building a decentralized application (dapp) on the Celo blockchain platform that allows users to add addresses to a whitelist. We will be using Vue.js as our frontend framework to build the user interface, and the Celo blockchain platform to store the whitelist data on the blockchain.

Before we dive into the technical details, let's briefly go over what a whitelist dapp is and why it might be useful. A whitelist dapp is a type of decentralized application that maintains a list of approved addresses that are allowed to perform certain actions on the blockchain, such as accessing a specific smart contract or executing a transaction. This can be useful for a variety of use cases, such as controlling access to a private smart contract, or ensuring that only authorized parties can participate in a specific token sale.

Throughout this tutorial, we will guide you through the process of building a basic Vue.js frontend that interacts with a Celo smart contract on the blockchain. By the end of this tutorial, you will have a basic understanding of how to build a decentralized application using Vue.js and the Celo blockchain platform.

To build this dapp, we will be using the following technologies:

1.  Vue.js: A popular JavaScript frontend framework for building user interfaces.
2.  Celo: A blockchain platform that allows for fast and secure transactions and smart contracts. Celo was designed to enable a new universe of financial solutions accessible to mobile users, creating a global financial ecosystem where an end-user can onboard into the Celo ecosystem with just a mobile number. It offers the following key features
  - Layer-1 protocol
  - EVM compatible
  - Proof-of-stake
  - Carbon negative
  - Mobile-first identity
  - Ultra-light clients
  - Localized stablecoins (cUSD, cEUR, cREAL)
  - Gas payable in multiple currencies
  For more information, click [here](https://docs.celo.org/general) to learn more about celo
3.  Solidity: A programming language used to write smart contracts on the Ethereum and Celo blockchain platforms.

## Requirements
- Writing the smart contract and deploying it on the celo blockchain using RemixIDE. Access should be given to the first 15 users for free who want to get in.
- There should be a website where people can go and enter into the whitelist. We will use Vue.js to build it and interact with our smart contract

## Prerequisites
- You can write code in Vue.js
- Have celo extension wallet installed and set up. If not, install [CeloExtensionWallet](https://chrome.google.com/webstore/detail/celoextensionwallet/kkilomkmpmkbdnfelcpgckmpcaemjcdh?hl=en) from Google Chrome store
- [Nodejs](https://nodejs.org/) installed on your machine.
- An IDE such as [Vscode](https://code.visualstudio.com/) or Sublime text.
- [RemixIDE](https://remix.ethereum.org/)
- Command line or similar software installed.

Let's start building 🚀


## Build And Deploy The Smart Contract
Now it's time to create a Solidity smart contract.
You can use any editor you like to make the contract. However, for this part of the tutorial we recommend the online IDE [RemixIDE](https://remix.ethereum.org/)
1. Go to Remix
![Remix IDE](https://github.com/ozo-vehe/vue-celo-whitelist/blob/master/remixIDE.png)

2. Create a new solidity file in the contract folder of remixIDE and name it `Whitelist.sol`

### 1. Writing the Contract

Specify the solidity version and add a license 
```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;
```

Import [`Ownable.sol`](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol) from Openzeppelin which helps you manage the Ownership of a contract
```solidity
import "@openzeppelin/contracts/access/Ownable.sol";
```

Define the contract
```solidity
contract Whitelist {
  // This is the contract's body, here you'll specify the logic for this contract.
}
```

Inside the contract create the following variables
```solidity
   // Max number of whitelisted addresses allowed
    uint256 public constant MAX_WHITELISTED_ADDRESSES = 20;
    
    // constant price for all quest
    uint256 public constant DEFAULT_QUEST_PRICE = 2 ether;

    // id to hold each quests
    uint256 public questId;

    // enum for player's status for a particular quest
    enum playerQuestStatus {
        NOT_JOINED,
        JOINED
    }

    // Struct to hold the data for each quest
    struct Quest {
        address owner;
        uint256 questId;
        uint256 numberOfPlayers;
        string title;
        uint8 reward;
        uint256 numberOfRewards;
        uint256 funds;
    }

    // a mapping of quests created
    mapping(uint256 => Quest) public quests;

    // a mapping of each players status for each quests
    mapping(address => mapping(uint256 => playerQuestStatus)) public playerQuestStatuses;

    // Create a mapping of whitelistedAddresses
    // if an address is whitelisted, we would set it to true, it is false by default for all other addresses.
    mapping(address => bool) public whitelistedAddresses;

    // numAddressesWhitelisted would be used to keep track of how many addresses have been whitelisted
    uint256 public numAddressesWhitelisted;

```

Here’s an explanation of what each of these variable represent:
- `MAX_WHITELISTED_ADDRESSES` -  this uint is a constant that holds the maximum number of whitelisted addresses allowed
- `DEFAULT_QUEST_PRICE` - this uint is a constant that holds the default price for all quests that users not whitelisted will have to pay before joining a quest
- `playerQuestStatus` - an [enum](https://docs.soliditylang.org/en/v0.8.19/structure-of-a-contract.html#enum-types) that tracks a player’s current status for a particular quest. There are 3 possible values - NOT_JOINED and JOINED
- `Quest` - a [struct](https://docs.soliditylang.org/en/v0.8.19/structure-of-a-contract.html#struct-types) that contains information describing a quest
- `questId` - this uint tracks the ID of the quest
- `quests` - a mapping that references the quest IDs to their quest
- `playerQuestStatuses` - a nested mapping that tracks each player’s quest status for every quest (using quest ID)
- `whitelistedAddresses` - a mapping that references an address with it's whitelisted status
- `numAddressesWhitelisted` - a uint that holds the number of addresses that have been whitelisted


Next, we will create our functions
1. `addAddressToWhitelist` function
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
As the name suggests, the purpose of this function is to add an address to the whitelist. In the function, we use two require statements, one to check if the caller of the function has been whitelisted and the second to check if the maximum number of whtelisted addresses has been exceeded. Recall that we need this check since we only want to allow users who have not been whitelisted to join the whitelist while there are still available spots left. After that check is passed, we add the address to the `whitelistedAddresses` mapping setting its value to true and increment the value of `numAddressesWhitelisted` by 1.


2. `createQuest` function
```solidity
    /*
    * @dev createQuest allows all users to be able to create quests
    */
    function createQuest(
        string calldata _title,
        uint8 _reward,
        uint256 _numberOfRewards
    ) external {
        uint256 _numberOfPlayers = 0;
        uint256 _funds = 0;
        quests[questId] = Quest(
            msg.sender,
            questId,
            _numberOfPlayers,
            _title,
            _reward,
            _numberOfRewards,
            _funds
        );

        questId++;
    }
```
This function creates a new quest. Our function takes in 3 parameters - `_title`, `_reward` and `_numberOfRewards`. In the function, we initilize the value of `_numberOfPlayers` and `funds` to zero then we assign the values of the `Quest` struct accordingly. Lastly, we increment the value of questId by 1.


3. `whitelistJoinQuest` function
```solidity
    /*
    * @dev whitelistJoinQuest allows users to join a quest
    ** whitelisted addresses can join a quest for free
    */
    function whitelistJoinQuest(uint256 id) external questExists(id) {
        // check if the user is whiteliseted
        require(whitelistedAddresses[msg.sender], "Only whitelisted users are permitted to carry out this function");
        // checks if the user has joined the quest
        require(playerQuestStatuses[msg.sender][id] == playerQuestStatus.NOT_JOINED, "Player has already joined this quest");

        // set the playerQuestStatus enum to joined
        playerQuestStatuses[msg.sender][id] = playerQuestStatus.JOINED;

        // increase the number of players value for the quest
        quests[id].numberOfPlayers ++;
    }
```
This function allows whitelisted users to join a quest. It takes in only 1 parameter - the questId of the quest that the user wishes to join. The first thing we need to do is to ensure that the questId submitted as part of the function call is valid, i.e. check if the quest exists. Since we’ll be requiring this check for another function we created a modifier `questExists()` that checks for this so we can reuse it later on

In the body of the function, the first thing we do is to check if the user is whitelisted or not using the `whitelistedAddresses` mapping, then we check if the user has indeed not yet joined this quest - we do so with the require statement. Then, if the check passes, then we change the value of the user’s status for that particular quest in playerQuestStatuses to JOINED. Lastly, we increment the numberOfPlayers value for that quest by 1.


4. `publicJoinQuest` function
```solidity
    /*
    * @dev publicJoinQuest allows non-whitelisted users to join a quest
    ** non-whitelisted address will pay a fee to join a quest
    */
    function publicJoinQuest(uint256 id) external payable questExists(id) {
        // checks if the user has joined the quest
        require(playerQuestStatuses[msg.sender][id] == playerQuestStatus.NOT_JOINED, "Player has already joined/submitted this quest");
        // check if the correct price has been used
        require(msg.value >= DEFAULT_QUEST_PRICE, "Celo sent is invalid");

        // add the fund to the quest
        quests[id].funds += msg.value;

        // set the playerQuestStatus enum to joined
        playerQuestStatuses[msg.sender][id] = playerQuestStatus.JOINED;

        // increase the number of players value for the quest
        quests[id].numberOfPlayers ++;
    }
```
This function allows any user to join a quest but they will have to pay for it. It takes in only 1 parameter - the questId of the quest that the user wishes to join. The first thing we need to do is to ensure that the questId submitted as part of the function call is valid using the `questExists()` modifier we created.

In the body of the function, we check if the amount sent by the user is equal to or greater than the default quest price defined earlier, we also check if the user has indeed not yet joined this quest. Both checks were done using the require statement. If the check passes, then we add the amount sent by the user to the quest's funds property and then change the value of the user’s status for that particular quest in `playerQuestStatuses` to JOINED. Lastly, we increment the numberOfPlayers value for that quest by 1.


5. `withdraw` function
```solidity
    /*
    * @dev withdraw allows the quest owner (deployer) to withdraw the celo from the contract
    */
    function withdraw(uint256 id) payable external onlyOwner {
        uint256 amount = quests[id].funds;

        (bool sent, ) = msg.sender.call{value: amount}("");
        require(sent, "Failed to send celo");

        quests[id].funds -= amount;
    }
```
This function allows the owner of a quest to withdraw funds saved in the quest. It takes in only 1 parameter - the questId of the quest that the owner wishes to withdraw funds from. The first thing we need to do is to ensure that the questId submitted as part of the function call is valid using the `questExists()` modifier we created. We also used the `onlyOwner` modifier imported from the `Ownable.sol` smart contract.

In the body of the function, we assing the funds stored in the particular quest to the variable `amount`, then using [`call()`](https://solidity-by-example.org/sending-ether/) we send the amount to the owner of the smart contract. Lastly, we decrement the funds value for that quest by the amount withdrawn.


6. Lastly we create our `questExists` modifier our two additional functions to enable our contract receive payment that is `receive()` and `fallback()`
```solidity
    modifier questExists(uint256 id) {
        require(quests[id].reward != 0, "Quest does not exist");
        _;
    }
    
    // Function to receive Ether. msg.data must be empty
    receive() external payable {}
    // Fallback function is called when msg.data is not empty
    fallback() external payable {}
```
`receive()` is called if msg.data is empty, otherwise `fallback()` is called.



The final file should look like this
```solidity
//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/access/Ownable.sol";

contract Whitelist is Ownable {

    // Max number of whitelisted addresses allowed
    uint256 public constant MAX_WHITELISTED_ADDRESSES = 20;
    // constant price for all quest
    uint256 public constant DEFAULT_QUEST_PRICE = 2 ether;

    // id to hold each quests
    uint256 public questId;

    // enum for player's status for a particular quest
    enum playerQuestStatus {
        NOT_JOINED,
        JOINED
    }

    // Struct to hold the data for each quest
    struct Quest {
        address owner;
        uint256 questId;
        uint256 numberOfPlayers;
        string title;
        uint8 reward;
        uint256 numberOfRewards;
        uint256 funds;
    }

    // a mapping of quests created
    mapping(uint256 => Quest) public quests;

    // a mapping of each players status for each quests
    mapping(address => mapping(uint256 => playerQuestStatus)) public playerQuestStatuses;

    // Create a mapping of whitelistedAddresses
    // if an address is whitelisted, we would set it to true, it is false by default for all other addresses.
    mapping(address => bool) public whitelistedAddresses;

    // numAddressesWhitelisted would be used to keep track of how many addresses have been whitelisted
    uint256 public numAddressesWhitelisted;


    /**
        addAddressToWhitelist - This function adds the address of the sender to the
        whitelist
     */
    function addAddressToWhitelist() public {
        // check if the user has already been whitelisted
        require(!whitelistedAddresses[msg.sender], "Sender has already been whitelisted");
        // check if the numAddressesWhitelisted < MAX_WHITELISTED_ADDRESSES, if not then throw an error.
        require(numAddressesWhitelisted < MAX_WHITELISTED_ADDRESSES, "More addresses cant be added, limit reached");
        // Add the address which called the function to the whitelistedAddress array
        whitelistedAddresses[msg.sender] = true;
        // Increase the number of whitelisted addresses
        numAddressesWhitelisted += 1;
    }

    /*
    * @dev createQuest allows all users to be able to create quests
    */
    function createQuest(
        string calldata _title,
        uint8 _reward,
        uint256 _numberOfRewards
    ) external {
        uint256 _numberOfPlayers = 0;
        uint256 _funds = 0;
        quests[questId] = Quest(
            msg.sender,
            questId,
            _numberOfPlayers,
            _title,
            _reward,
            _numberOfRewards,
            _funds
        );

        questId++;
    }
    
    /*
    * @dev whitelistJoinQuest allows users to join a quest
    ** whitelisted addresses can join a quest for free
    */
    function whitelistJoinQuest(uint256 id) external questExists(id) {
        // check if the user is whiteliseted
        require(whitelistedAddresses[msg.sender], "Only whitelisted users are permitted to carry out this function");
        // checks if the user has joined the quest
        require(playerQuestStatuses[msg.sender][id] == playerQuestStatus.NOT_JOINED, "Player has already joined/submitted this quest");

        // set the playerQuestStatus enum to joined
        playerQuestStatuses[msg.sender][id] = playerQuestStatus.JOINED;

        // increase the number of players value for the quest
        quests[id].numberOfPlayers ++;
    }

    /*
    * @dev publicJoinQuest allows non-whitelisted users to join a quest
    ** non-whitelisted address will pay a fee to join a quest
    */
    function publicJoinQuest(uint256 id) external payable questExists(id) {
        // checks if the user has joined the quest
        require(playerQuestStatuses[msg.sender][id] == playerQuestStatus.NOT_JOINED, "Player has already joined/submitted this quest");
        // check if the correct price has been used
        require(msg.value >= DEFAULT_QUEST_PRICE, "Celo sent is invalid");

        // add the fund to the quest
        quests[id].funds += msg.value;

        // set the playerQuestStatus enum to joined
        playerQuestStatuses[msg.sender][id] = playerQuestStatus.JOINED;

        // increase the number of players value for the quest
        quests[id].numberOfPlayers ++;
    }
    /*
    * @dev withdraw allows the quest owner (deployer) to withdraw the celo from the contract
    */
    function withdraw(uint256 id) payable external onlyOwner {
        require(msg.sender == quests[id].owner, "Only owner of this quest can withraw the funds");

        uint256 amount = quests[id].funds;

        (bool sent, ) = msg.sender.call{value: amount}("");
        require(sent, "Failed to send celo");

        quests[id].funds -= amount;
    }

    modifier questExists(uint256 id) {
        require(quests[id].reward != 0, "Quest does not exist");
        _;
    }

    // Function to receive Ether. msg.data must be empty
    receive() external payable {}
    // Fallback function is called when msg.data is not empty
    fallback() external payable {}

}
```

### 2. Deploying the Smart Contract on the Celo Blockchain
Create a Celo wallet and deploy your contract to the Celo testnet alfajores.
If you don't have celo extension wallet installed, follow the prompt below to install and set up your celo extension wallet

1. Install the [CeloExtensionWallet](https://chrome.google.com/webstore/detail/celoextensionwallet/kkilomkmpmkbdnfelcpgckmpcaemjcdh?hl=en) from the Google Chrome Store.
![](https://raw.githubusercontent.com/dacadeorg/celo-development-101/main/content/gifs/celo_install_celo_extension_wallet.gif)

2. Create a wallet.
![](https://raw.githubusercontent.com/dacadeorg/celo-development-101/main/content/gifs/celo_create_wallet.gif)

3. Get Celo token for the alfajores testnet from [https://celo.org/developers/faucet](https://celo.org/developers/faucet)
![](https://raw.githubusercontent.com/dacadeorg/celo-development-101/main/content/gifs/celo_get_token_from_faucet.gif)

4. Install the Celo remix plugin and deploy your contract.
In this tutorial, we will deploy our smart contract, `Whitelist.sol` as opposed to `Marketplace.sol` shown below


![](https://raw.githubusercontent.com/dacadeorg/celo-development-101/main/content/gifs/celo_install_remix_plugin_and_deploy_contract.gif)
  
Great! You deployed your first contract on the Celo blockchain. Congratulations 🎉.

5. Now we will create two new quests with the following data.

On the deployed contract, click on `createQuest` and inser the following details.
![](https://github.com/ozo-vehe/vue-celo-whitelist/blob/master/tutorial_assets/createQuest.png)

Create a new quest with the following information:

The first quest data should be
- `_title`: Introduction to Vue.js
- `_reward`: 2
- `_numberOfRewards`: 8

Click on `transact` and confirm the transaction

The second quest data should be
- `_title`: Debugging and Deploying with RemixIDE
- `_reward`: 3
- `_numberOfRewards`: 5

Click on `transact` and confirm the transaction


6. Saving the smart contract abi and address
When you compile your contract in Remix, Remix also creates the ABI in the form of a JSON for your contract. Copy the JSON and save it.

![](https://github.com/ozo-vehe/vue-celo-whitelist/blob/master/tutorial_assets/contract_abi.png)


It also creates an address of the contract which you need to find your contract and interact with it. Copy the address and save it.

![](https://github.com/ozo-vehe/vue-celo-whitelist/blob/master/tutorial_assets/contract_address.png)


In the next section, you will learn how to create a front-end that will make use of your contract.


## Building The Frontend With Vue
To develop the website we will be using Vue, a javascript framework used to build interactive websites. It offers the following;
- Approachable: it builds on top of standard HTML, CSS, and JavaScript with intuitive API and world-class documentation.
- Performant: truly reactive, compiler-optimized rendering system that rarely requires manual optimization.
- Versatile: a rich, incrementally adoptable ecosystem that scales between a library and a full-featured framework.

1. To start with, we will use vite, the official Vue project scaffolding tool. 
Make sure you have an up-to-date version of Node.js installed, then run the following command in your command line terminal

```bash
npm create vite@latest vue-celo-whitelist -- --template vue
```
2. Navigate to the project.

```bash
cd vue-celo-whitelist
```

3. Install the required dependencies.
```bash
npm install
```

4. Open the project in VS Code
```bash
code .
```

5. Start up a local development server. Using the command line or the terminal in VS Code.
```bash
npm run dev
```

The project directory should look something like this

![](https://github.com/ozo-vehe/vue-celo-whitelist/blob/master/tutorial_assets/project_setup.png)


6. In the `src` folder, delete the `components` folder(as the App.vue file will be sufficient for this tutorial) and the `vue.svg` file in the `assets` folder. Replace this file with this image [whitelist.png](https://github.com/ozo-vehe/vue-celo-whitelist/blob/master/tutorial_images/whitelist.png).

7. Create a new file called `contract.js` in the src folder and paste in the following code

```js
export const contractAbi = YOUR_CONTRACT_ABI;
export const contractAddress = "YOUR_CONTRACT_ADDRESS";
```

Replace YOUR_CONTRACT_ABI with the ABI of your Whitelist Contract and YOUR_CONTRACT_ADDRESS with the address of the whitelist contract that you deployed. All this was saved earlier during the tutorial

8. In the `App.vue` file, replace the code with the following code, explanation of the code can be found in the comments.

```vue
<script setup>
  import { ref, reactive } from "vue";

  // DATA/VARIABLES
  const isConnected = ref(false); // variable for holding the state of a wallet, if it's connected or not
  const walletLoading = ref(false); // variable to show or hide spinner animation for connwct wallet button
  const accessLoading = ref(false); // variable to show or hide spinner animation for get access button
  const joinLoading = ref(false); // variable to show or hide spinner animation for join quest button
  const withdrawLoading = ref(false); // variable to show or hide spinner animation for withdraw button
  const isWhitelisted = ref(false); // checks if an address has already been whitelisted or not
  const contractOwner = ref(null); // variable for the contractOwner of the smart contract

</script>

<template>
  <main>
    <nav>
      <button v-if="isConnected" disabled>Wallet Connected</button>
      <button v-else @click="connectWallet">
        <span v-if="walletLoading" class="loader"></span>
        <span v-else>Connect Wallet</span>
      </button>
      <p v-if="isConnected">{{ cUSDBalance }} <span>CELO</span></p>
      <p v-else>0.00 <span>CELO</span></p>
    </nav>

    <div class="whitelist" v-if="!numberOfWhitelistedAddresses">
      <div class="whitelistHeader">
        <h1>Welcome to <span>WhiteListedChain</span></h1>
        <p>
          Secure, transparent access to decentralized networks. 
          Click the button below to get early access to our hosted quests.
        </p>
      </div>

      <div class="whitelistImage">
        <img src="./assets/whitelist.png" />
      </div>
    </div>


    <div class="quests" v-else>
      <div class="earlyAccess">
        <p>{{ numberOfWhitelistedAddresses }} have already joined the Whitelist</p>
        <p v-if="isWhitelisted" class="whitelisted">Thanks for joining the WhiteListedChain's whitelist</p>
        <button v-else @click="joinWhitelist">
          <span v-if="accessLoading" class="loader"></span>
          <span v-else>Get Early Access Pass</span>
        </button>
      </div>

      <div v-if="questsData">
        <h2>
          <u>All Quests:</u>
        </h2>

        <div>
          <div class="quest" v-for="(quest, index) in questsData" :key="index">
            <h3>{{ quest.title }}</h3>
            <ul>
              <li>questId: {{ quest.questId }}</li>
              <li>number of players: {{ quest.numberOfPlayers }}</li>
              <li>reward: {{ quest.reward }}</li>
              <li>number of rewards available: {{ quest.numberOfRewards }}</li>
            </ul>
          </div>
        </div>
      </div>
        
      <div class="questActions">
        <h2>
          <u>Actions:</u>
        </h2>
        
        <div>
          <input type="text" placeholder="Quest Id" v-model="questId" /> <br>
          <button @click="joinQuest">        
            <span v-if="joinLoading" class="loader"></span>
            <span v-else>Join Quest</span>
          </button>
          <button v-if="contractOwner === kit.defaultAccount" @click="withdrawFunds">
            <span v-if="withdrawLoading" class="loader"></span>
            <span v-else>Withdraw</span>
          </button>
        </div>
      </div>
    </div>
  </main>
</template>

<style scoped>
  main {
    font-family: 'JetBrains Mono', monospace;
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
    min-width: 100px;
    overflow: hidden;
    background-color: #e096e0;
    color: #fff;
    padding: 10px 10px;
    font-size: 0.8rem;
    font-family: inherit;
    cursor: pointer;
  }
  button:disabled {
    cursor: default;
    background-color: #e096e085;
  }
  button .loader {
    display: inline-block;
    border: thin solid #e096e0;
    width: 10px;
    height: 10px;
    margin: 0px;
    border-radius: 50%;
    border-left: 2px solid #fff;
    animation: spinner 0.3s linear infinite;
  }
  @keyframes spinner {
    from { transform: rotate(0deg);}
    to { transform: rotate(360deg);}
  }

  .whitelist, .quests {
    display: flex;
    min-height: calc(100vh - 130px);
    justify-content: center;
    gap: 10px 30px;
    align-items: center;
    padding: 10px 5%;
  }
  .whitelist h1 {
    font-size: 2rem;
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


  .quests {
    display: flex;
    min-height: calc(100vh - 130px);
    flex-direction: column;
    justify-content: center;
    gap: 10px 30px;
    align-items: center;
    padding: 10px 5%;
  }
  .quests > div {
    text-align: center;
  }
  .quests h2 {
    text-align: center;
  }

  .earlyAccess p {
    margin: 5px 0px;
  }
  .earlyAccess button {
    margin: 0px auto;
  }
  .questActions input {
    margin: 10px;
    height: 20px;
    width: 100px;
    font-family: inherit;
  }
  .questActions button {
    display: inline;
    margin: 0px 5px;
  }
  
  .quest {
    padding: 10px;
    border: thin solid #f8f7f7;
    text-align: left;
    margin: 10px 0px;
  }
  .quest * {
    text-transform: capitalize;
  }
</style>

```

9. Go to the `style.css` file in the `src` folder and replace the code with the following
```css
body {
  margin: 0px;
  padding: 0px;
  box-sizing: border-box;
}
```


Your project should look like this

![](https://github.com/ozo-vehe/vue-celo-whitelist/blob/master/tutorial_assets/image1.png)


10. We will now install a few packages needed to interact with our smart contract deployed on the celo blockchain. Run the following command on the terminal

```
npm install web3 @celo/contractkit
```
`@celo/contractkit` helps us interact with the Celo blockchain and the smart contract deployed to this blockchain

```
npm install vite-plugin-node-polyfills
```
[`vite-plugin-node-polyfills`](https://www.npmjs.com/package/vite-plugin-node-polyfills) is a vite plugin to polyfill node's core modules for browser environments. Since browsers do not support node's core modules, packages that use them must be polyfilled to function in browser environments.


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

11. In the `App.vue` file, import the packages installed and add the following variables as they will be needed for this tutorial. Explanation of each variable can be found in the code

```vue
<script setup>
  import { ref, reactive } from "vue";
  
  import Web3 from "web3";
  import { newKitFromWeb3 } from "@celo/contractkit";
  import { contractAbi, contractAddress } from './contract';

  const ERC20_DECIMALS = 18;  // for balance conversion to a readable amount
  let kit = reactive(null);
  let CELOBalance = ref(null);  // for holding the user's cUSD balance
  const numberOfWhitelistedAddresses = ref(0);  //  For storing the number of whitelisted addresses
  let contract = reactive(null);  //  to store a contract instance
  let questsData = ref(null); // holds all the data for every quest
  let questId = ref(null); // quest id

</script>

```

- We will now write our functions, to interact with the deployed smart contract. Explanation for each functions can be found in the code samples

1. `connectWallet()` function

```vue

<script setup>
  ...
 
  // Connect to the celo extension wallet
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

        // Set isConnected to true and walletLoading to false
        isConnected.value = true;
        walletLoading.value = false;

        // Create a new contract instance using the contract info saved in contract.js file(contractAbi and contractAddress) and assign it to the reactive contract variable created earlier
        contract = new kit.web3.eth.Contract(contractAbi, contractAddress)

        // set the owner of the smart contract to the contractOwner variable
        contractOwner.value = await contract.methods.owner().call();

        console.log(contractOwner.value);

        // Get the number of whitelisted addresses and assign it to the numberOfWhiteListedAddresses ref variable
        numberOfWhitelistedAddresses.value =  await contract.methods.numAddressesWhitelisted().call();
        
        // Check if the connect account address has been whitelisted or not and assign it to the isWhitelisted ref variable
        isWhitelisted.value = await contract.methods.whitelistedAddresses(kit.defaultAccount).call();

        // call the getQuestsInfo function
        await getQuestsInfo();
      } catch (error) {
        console.log(error)
      }
    } else {
      alert("Celo Extension Walltet Not Installed");
    }
  }

</script>
```
In this function we first use an if statement to check if the user has Celo Extension Wallet installed in their browser - if they do not, then we print the message "Celo Extension Walltet Not Installed". 

After we know that the user has the Celo Extension Wallet installed, we’ll need to actually connect to it. We can do this using the window.celo.enable method. After the user consents to connecting with the website, we’ll save the array of accounts into a variable accounts. 

However, we won’t be storing the entire array; we’ll only be saving the first account in the array. We’ll store the first account in the kit variable created earlier.

Then we call the `getBalance()` function which we will create later during the tutorial, assign the neccessary variables their values from the deployed smart contract and call the `getQuestsInfo()` function which we will create later during the tutoriala button that connects to our connectWalletHandler function.


2. `getBalance()` function

```vue
<script setup>
  ...
  
  // Get user balance in cUSD
  const getBalance = async() => {
    // Using the getTotalBalance function from kit, get the total balance and assign it to a totalBalance variable
    const totalBalance = await kit.getTotalBalance(kit.defaultAccount);
    
    // Using the ERC20_DECIMAL constant, convert the total balance to a readable amount set to 2 decimal places
    // assign the value to the CELOBalance ref created earlier 
    CELOBalance.value = totalBalance.CELO.shiftedBy(-ERC20_DECIMALS).toFixed(2);
  }

</script>
```
In this function we use the `getTotalBalance()` method to get the total balance of the user. This will return all the balance of the user including `cUSD`, `CELO`, `cEUR` etc. Since we want the `CELO` balance, we store this value in the `CELOBalance` variable created earlier.


3. `joinWhitelist()` function

```vue
<script setup>
  ...
  
  // Add an account to the whitelist
  const joinWhitelist = async() => {
    // Change the accessLoading ref variable to false to stop the walletLoading animation
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
        
      } catch(error) {
        alert(error);
      }
    }
    else {
      alert("Connect Wallet A Celo Extension Wallet");
    }
    
    // Change the accessLoading ref variable to false to stop the walletLoading animation
    accessLoading.value = false;
  }
</script>
```
In this function we use an if statement to check if the user's account is connected or not, then we call the `addAddressesToWhitelist` function from the smart contract to add the user to the whitelist. fubally we get the number of whitelisted addresses from the smart contract and assign the value to `numberOfWhitelistedAddresses` variable and set the `isWhitelisted` and `accessLoading` variable to true.


4. `getQuestsInfo()` function
```vue
<script setup>
...

  // Get quests info from the smart contract
  const getQuestsInfo = async() => {
    try {
      const questId = await contract.methods.questId().call();
      console.log(questId);
      let allQuestsInfo = [];
      let thisQuest;
      for (let i = 0; i < questId; i++) {
        thisQuest = await contract.methods.quests(i).call();
        allQuestsInfo.push(thisQuest);
      }

      questsData.value = allQuestsInfo;
    } catch (err) {
      console.log("getQuestsInfo error...");
      console.log(err);
    }
  };
 </script>
```
This function contains the code used to query for quest information. First, we get the value of `questId`, this will tell us how many quests there are currently. We instantiate a new array allQuestsInfo, which will be used to store the information of each quest.. We then create a for loop and push each quests’ information to our allQuestsInfo array. Finally, we use the `questsData` variable created earlier to store this information.


5. `joinQuest()` function
```vue
<script setup>
  // Join a quest
  const joinQuest = async () => {
    joinLoading.value = true;
    try {
      if (!questId.value) {
        alert("Input quest ID before proceeding");
      } else {
        if(isWhitelisted.value) {
          await contract.methods.whitelistJoinQuest(questId.value).send({ from: kit.defaultAccount });
        } else {
          const questPrice = await contract.methods.DEFAULT_QUEST_PRICE().call();
          await contract.methods.publicJoinQuest(questId.value).send({ from: kit.defaultAccount, value: questPrice });
        }
        await getQuestsInfo();
        await getBalance();
        alert("Successfully joined the quest");
      }
    } catch (err) {
      console.log(err);
      alert("Error encountered! refer to console log to debug");
    }
    joinLoading.value = false;
  };
</script>
```
This is the function we’ll be creating to allow the user to join a quest. Notice that first checked if the user is whitelisted. For whitelisted users, we call the `whitelistJoinQuest` function of our contract, passing in the questId as its parameter. For the non-whitelisted address, we get the `DEFAULT_QUEST_PRICE` from the smart contract, then we call the `publicJoinQuest` function passing the questId and the `questPrice`. Finally, we wait to make sure that the transaction goes through.


6. `withdrawFunds()` function
```vue
<script setup>

</script>
```


### Final code for `App.vue`
```vue
<script setup>
  import { ref, reactive } from "vue";
  import Web3 from "web3";
  import { newKitFromWeb3 } from "@celo/contractkit";
  import { contractAbi, contractAddress } from './contract';

  // DATA/VARIABLES
  const isConnected = ref(false); // variable for holding the state of a wallet, if it's connected or not
  const walletLoading = ref(false); // variable to show or hide spinner animation for connect wallet button
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

  // Connect to the celo extension wallet
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

        // Create a new contract instance using the contract info saved in contract.js file(contractAbi and contractAddress) and assign it to the reactive contract variable created earlier
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
    // Change the accessLoading ref variable to false to stop the loading animation
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
        
        // Change the accessLoading ref variable to false to stop the loading animation
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
After testing your DApp and checking that everything behaves correctly, upload your project to a new GitHub repository. For more information on how to push your code to Github, read this article ["push to github"](https://www.git-tower.com/learn/git/faq/push-to-github/).

If needed, you can create a readme file for your project that explains your dapp and includes a link to your Dapp.


## Deploying To Vercel
We will now deploy your dApp so that everyone can see your website and you can share it with everyone.

Follow these steps to deploy your DApp to vercel
1.  Go to Vercel and sign in with your GitHub.
2.  Then click on Add New button, select Project from the dropdown menu, and then select your Whitelist DApp repo from the options given.
3.  When configuring your new project, Vercel will allow you to customize your Root Directory. However, for this project, we will leave it at the Root Directory
4.  Select the Framework as Vite
5.  Click Deploy

Now you can see your deployed website by going to your dashboard, selecting your project, and copying the URL beneath domains!

## Conclusion
That’s it! Congratulations! You are done with the tutorial, in this tutorial have built a DApp using Vue and celo, pushed your code to Github, and deployed it to vercel! 🎉
