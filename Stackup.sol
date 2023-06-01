// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract StackUp {
    enum PlayerQuestStatus {
        NOT_JOINED,
        JOINED,
        SUBMITTED,
        //  Added to track player's status for rewarded, approved, & rejected quests
        REWARDED,
        APPROVED,
        REJECTED
    }

    struct Quest {
        uint256 questId;
        uint256 numberOfPlayers;
        string title;
        uint8 reward;
        uint256 numberOfRewards;
        uint256 numberOfRewardsLeft; // Add this to track the number of rewards remaining
    }

    // Created to record player's rewards
    struct PlayerRewards {
        uint256 totalEarnings;
        uint256 totalExp;
    }

    address public admin;
    uint256 public nextQuestId;
    mapping(uint256 => Quest) public quests;
    mapping(address => mapping(uint256 => PlayerQuestStatus))
        public playerQuestStatuses;

    //  To track player's rewards    
    mapping(address => PlayerRewards) public playerRewards;


    constructor() {
        admin = msg.sender;
    }

    function createQuest(
        string calldata title_,
        uint8 reward_,
        uint256 numberOfRewards_
    ) external isAdmin() {
        quests[nextQuestId].questId = nextQuestId;
        quests[nextQuestId].title = title_;
        quests[nextQuestId].reward = reward_;
        quests[nextQuestId].numberOfRewards = numberOfRewards_;
        // Assign numberOfRewards to numberOfRewardsLeft
        quests[nextQuestId].numberOfRewardsLeft = numberOfRewards_;
        nextQuestId++;
    }

    // function for admin to edit quest
    function editQuest(
        uint256 questId,
        string calldata newTitle,
        uint8 newReward,
        uint256 newNumberOfRewards
    ) external isAdmin() questExists(questId) {
        Quest storage quest = quests[questId];
        quest.title = newTitle;
        quest.reward = newReward;
        quest.numberOfRewards = newNumberOfRewards;
        quest.numberOfRewardsLeft = newNumberOfRewards;
    }

    // function for admin to delete quest
    function deleteQuest(uint256 questId)
        external
        isAdmin()
        questExists(questId)
    {
        delete quests[questId]; // DELETE!
    }

    // function for admin to reward or approve an accepted quest submission
    function acceptQuest(uint256 questId, address player)
        external
        isAdmin()
        questExists(questId)
    {
        // Check if player previously submitted (or submitted, then rejected) the quest for review
        require(
            playerQuestStatuses[player][questId] ==
            PlayerQuestStatus.SUBMITTED ||
            playerQuestStatuses[player][questId] ==
            PlayerQuestStatus.REJECTED,
            "Player has not submitted quest OR Quest has already been rewarded/approved for the player"
        );
        // Checks if any player has joined the quest
        require(
            quests[questId].numberOfPlayers > 0,
            "No players joined this quest"
        );

        //  Add 500Exp to Player's totalExp for accepted quest submission (Either Approved/Rewarded)
        playerRewards[player].totalExp += 500;

        //  Checks if there are remaining rewards, REWARD!
        if (quests[questId].numberOfRewardsLeft > 0) {
            //  Add Reward to Player's totalEarning
            playerRewards[player].totalEarnings += quests[questId].reward;
            //  Reduce the number of rewards left by 1
            quests[questId].numberOfRewardsLeft--;
            //REWARD!
            playerQuestStatuses[player][questId] = PlayerQuestStatus.REWARDED; 
        }
        //  if there's no reward remaining, APPROVE!
        else {
            //APPROVE!
            playerQuestStatuses[player][questId] = PlayerQuestStatus.APPROVED; 
        }
        
    }

    // function for admin to reject quest
    function rejectQuest(uint256 questId, address player)
        external
        isAdmin()
        questExists(questId)
    {
        // Checks if any player has joined the quest
        require(
            quests[questId].numberOfPlayers > 0,
            "No players joined this quest"
        );

        // Checks if the player has previously submitted the quest for review
        require(
            playerQuestStatuses[player][questId] ==
                PlayerQuestStatus.SUBMITTED ||
                playerQuestStatuses[player][questId] ==
                PlayerQuestStatus.APPROVED ||
                playerQuestStatuses[player][questId] ==
                PlayerQuestStatus.REWARDED,
            "Player has not submitted the quest OR Quest has already been rejected for player"
        );

        //  If quest was previously APPROVED,
        if (playerQuestStatuses[player][questId] == PlayerQuestStatus.APPROVED) {
            //  Deduct Exp from Player's totalExp
            playerRewards[player].totalExp -= 500;
            //  REJECT!
            playerQuestStatuses[player][questId] = PlayerQuestStatus.REJECTED; 

        }

        //  If quest was previously REWARDED,
        else if (playerQuestStatuses[player][questId] == PlayerQuestStatus.REWARDED) {
            //  Deduct Reward from Player's totalEarnings
            playerRewards[player].totalEarnings -= quests[questId].reward;
            //  Deduct Exp from Player's totalExp
            playerRewards[player].totalExp -= 500;
            //  Increase the number of rewards left by 1
            quests[questId].numberOfRewardsLeft++;
            playerQuestStatuses[player][questId] = PlayerQuestStatus.REJECTED;

        //  If quest was has not been rewarded/approved before but status is SUBMITTED
        } else {
            //  REJECT!
            playerQuestStatuses[player][questId] = PlayerQuestStatus.REJECTED;
        }
    }

    // function to join quest
    function joinQuest(uint256 questId) external questExists(questId) {
        require(
            playerQuestStatuses[msg.sender][questId] ==
                PlayerQuestStatus.NOT_JOINED,
            "Player has already joined/submitted this quest"
        );
        playerQuestStatuses[msg.sender][questId] = PlayerQuestStatus.JOINED;

        quests[questId].numberOfPlayers++;
    }

    // function to submit quest
    function submitQuest(uint256 questId) external questExists(questId) {
        require(
            playerQuestStatuses[msg.sender][questId] ==
                PlayerQuestStatus.JOINED,
            "Player must first join the quest"
        );
        playerQuestStatuses[msg.sender][questId] = PlayerQuestStatus.SUBMITTED;
    }

    // modifier to check if there exists a quest with specified questId
    modifier questExists(uint256 questId) {
        require(quests[questId].reward != 0, "Quest does not exist");
        _;
    }
    // modifier to allow only the admin to perform a function
    modifier isAdmin() {
        require(msg.sender == admin, "Only the admin can perform this action");
        _;
    }
}
