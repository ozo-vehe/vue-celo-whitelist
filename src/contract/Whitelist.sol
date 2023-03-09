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