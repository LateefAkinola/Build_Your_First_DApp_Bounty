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
        uint256 numberOfRewardsLeft; // Add this to track the number of rewards left
    }

    address public admin;
    uint256 public nextQuestId;
    mapping(uint256 => Quest) public quests;
    mapping(address => mapping(uint256 => PlayerQuestStatus))
        public playerQuestStatuses;

    constructor() {
        admin = msg.sender;
    }

    function createQuest(
        string calldata title_,
        uint8 reward_,
        uint256 numberOfRewards_
    ) external onlyAdmin {
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
    ) external onlyAdmin() questExists(questId) {
        Quest storage quest = quests[questId];
        quest.title = newTitle;
        quest.reward = newReward;
        quest.numberOfRewards = newNumberOfRewards;
        quest.numberOfRewardsLeft = newNumberOfRewards;
    }

    // function for admin to delete quest
    function deleteQuest(uint256 questId)
        external
        onlyAdmin
        questExists(questId)
    {
        delete quests[questId]; // DELETE!
    }


    // function for admin to reward or approve quest an accepted quest submission
    function acceptQuest(uint256 questId, address player)
        external
        onlyAdmin
        questExists(questId)
    {
        // Check if player has submitted the quest
        require(
            playerQuestStatuses[player][questId] == PlayerQuestStatus.SUBMITTED,
            "Player has not submitted the quest"
        );
        // Check if any player has joined the quest
        require(
            quests[questId].numberOfPlayers > 0,
            "No players joined this quest"
        );

        if (quests[questId].numberOfRewardsLeft > 0) { //  Check if there are remaining rewards
            playerQuestStatuses[player][questId] = PlayerQuestStatus.REWARDED;  //REWARD!
            quests[questId].numberOfRewardsLeft--;
        } else {    //  if no there's no reward remaining, APPROVE!
            playerQuestStatuses[player][questId] = PlayerQuestStatus.APPROVED;  //APPROVE!
        }
    }


    // function for admin to reject quest
    function rejectQuest(uint256 questId, address player)
        external
        onlyAdmin
        questExists(questId)
    {
        // Check if any player has joined the quest
        require(
            quests[questId].numberOfPlayers > 0,
            "No players joined this quest"
        );

        playerQuestStatuses[player][questId] = PlayerQuestStatus.REJECTED;  //  REJECT!
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
    modifier onlyAdmin() {
        require(msg.sender == admin, "Only the admin can perform this action");
        _;
    }
}
