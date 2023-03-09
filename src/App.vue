<script setup>
  import { ref, reactive } from "vue";
  import Web3 from "web3";
  import { newKitFromWeb3, CeloContract } from "@celo/contractkit";
  import { contractAbi, contractAddress } from './contract';

  // DATA/VARIABLES
  const isConnected = ref(false); // variable for holding the state of a wallet, if it's connected or not
  const walletLoading = ref(false); // variable to show or hide spinner animation for connect wallet button
  const accessLoading = ref(false); // variable to show or hide spinner animation for get access button
  const joinLoading = ref(false); // variable to show or hide spinner animation for join quest button
  const withdrawLoading = ref(false); // variable to show or hide spinner animation for withdraw button
  const isWhitelisted = ref(false); // checks if an address has already been whitelisted or not
  const contractOwner = ref(null); // variable for the contractOwner of the smart contract
  
  const ERC20_DECIMALS = 18;  // for balance conversion to a readable amount
  let kit = reactive(null);
  let CELOBalance = ref(null);  // for holding the user's cUSD balance
  const numberOfWhitelistedAddresses = ref(0);  //  For storing the number of whitelisted addresses
  let contract = reactive(null);  //  to store a contract instance
  let questsData = ref(null); // holds all the data for every quest
  let questId = ref(null); // quest id


  // METHODS/FUNCTIONS

  // Get user balance in cUSD
  const getBalance = async() => {
    // Using the getTotalBalance function from kit, get the total balance and assign it to a totalBalance variable
    const totalBalance = await kit.getTotalBalance(kit.defaultAccount);
    
    // Using the ERC20_DECIMAL constant, convert the total balance to a readable amount set to 2 decimal places
    // assign the value to the CELOBalance ref created earlier 
    CELOBalance.value = totalBalance.CELO.shiftedBy(-ERC20_DECIMALS).toFixed(2);
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
      alert("Connect Wallet (A Celo Extension Wallet)");
    }
    
    // Change the accessLoading ref variable to false to stop the walletLoading animation
    accessLoading.value = false;
  }

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

  // Wothdraw funds
  const withdrawFunds = async() => {
    withdrawLoading.value = true;
    try {
      if(questId.value) {
        const contractQuest = await contract.methods.quests(questId.value).call();
        const {owner, funds} = contractQuest;

        if(owner !== contractOwner.value) {
          alert("Sorry, you are not the quest owner")
        } else {
          if(funds >= 1) {
            await contract.methods.withdraw(questId.value).send({ from: kit.defaultAccount });
          } else {
            alert("No funds to withdraw")
          }
        }
      } else {
        alert("Input quest ID before proceeding")
      }
      await getBalance();
    } catch (err) {

    }
    withdrawLoading.value = false;
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
      <p v-if="isConnected">{{ CELOBalance }} <span>CELO</span></p>
      <p v-else>0.00 <span>CELO</span></p>
    </nav>

    <div class="whitelist" v-if="!numberOfWhitelistedAddresses">
      <div class="whitelistHeader">
        <h1>Welcome to <span>WhiteListedChain</span></h1>
        <p>
          Secure, transparent access to decentralized networks. 
          Connect your wallet to get early access to our hosted quests.
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
