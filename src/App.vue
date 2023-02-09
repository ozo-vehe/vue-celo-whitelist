<script setup>
  import { ref, reactive } from "vue";
  import Web3 from "web3";
  import { newKitFromWeb3 } from "@celo/contractkit";
  import { contractAbi, contractAddress } from './contract';

  // DATA/VARIABLES
  const isConnected = ref(false);
  const ERC20_DECIMALS = 18;
  let kit = reactive(null);
  let cUSDBalance = ref(null);
  const loading = ref(false);
  const numberOfWhitelistedAddresses = ref(0);
  const isWhitelisted = ref(false);
  let contract = reactive(null);

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
    console.log("Connecting...");
    // Check if celo extension is installed else, user is prompted to install the extension
    if(window.celo) {
      try {
        loading.value = true;

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
        loading.value = false;

        // Create a new contract instance using the contract info saved in contract.js file(contractAbi and contractAddress) and assing it to the reactive contract variable created earlier
        contract = new kit.web3.eth.Contract(contractAbi, contractAddress)

        // Get the number of whitelisted addresses and assign it to the numberOfWhiteListedAddresses ref variable
        numberOfWhitelistedAddresses.value =  await contract.methods.numAddressesWhitelisted().call();
        // Check if the connect account address has been whitelisted or not and assign it to the isWhitelisted ref variable
        isWhitelisted.value = await contract.methods.whitelistedAddresses(kit.defaultAccount).call();
      
        // cUSDBalance.value = null;
      } catch (error) {
        console.log(error)
      }
    } else {
      alert("Celo Extension Walltet Not Installed");
    }
  }

  const joinWhitelist = async() => {
    console.log("Joining whitelist...");
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
  }
</script>

<template>
  <main>
    <nav>
      <button v-if="isConnected" disabled>Wallet Connected</button>
      <button v-else @click="connectWallet">
        <span v-if="loading" class="loader"></span>
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
          <button v-else @click="joinWhitelist">Get Early Access Pass</button>
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
