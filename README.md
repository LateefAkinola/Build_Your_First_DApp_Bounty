# Build_Your_First_DApp_Bounty
The `StackUp` contract is a smart contract written in Solidity. It provides functionality for managing quests and player interactions within a game.
-------------------------------------------------------------------------
#### IMPORTANT ADDITIONS:
- Ability to call/query the rewards garnered by a player
- Functionality for admin to be able to edit and delete existing quests
- Functionalities for admin to accept (REWARD/APPROVE) and reject quest submissions:
- Functionalities for admin to Re-Review Quest (REJECT/REWARD/APPROVE) and rewards are added/deducted depending on the case

#### NOTE: 
I've seen some cases whereby some players were rewarded twice for a quest by mistake, therefore, it was carefully factored in the code so that admin cannot reward/approve a quest for a player more than once. 
----------------------------------------------------------------------------
## EXPLANATION OF THE CODE:

### Enum PlayerQuestStatus
This enum defines the possible statuses of a player's quest, including:
- `NOT_JOINED`: The player has not joined the quest.
- `JOINED`: The player has joined the quest.
- `SUBMITTED`: The player has submitted the quest.
- `REWARDED`: The quest has been rewarded to the player.
- `APPROVED`: The quest has been approved for the player.
- `REJECTED`: The quest has been rejected for the player.

### Struct Quest
This struct represents a quest and contains the following properties:
- `questId`: The unique identifier of the quest.
- `numberOfPlayers`: The number of players who have joined the quest.
- `title`: The title or name of the quest.
- `reward`: The reward associated with completing the quest.
- `numberOfRewards`: The total number of rewards available for the quest.
- `numberOfRewardsLeft`: The number of rewards remaining for the quest.

### Struct PlayerRewards
This struct stores information about a player's rewards and includes the following properties:
- `totalEarnings`: The total earnings or rewards accumulated by the player.
- `totalExp`: The total experience points earned by the player.

### Public Variables
- `admin`: The address of the contract's admin.
- `nextQuestId`: The ID of the next quest to be created.
- `quests`: A mapping of quest IDs to their corresponding `Quest` structs.
- `playerQuestStatuses`: A mapping that stores the quest status for each player.
- `playerRewards`: A mapping that stores the rewards earned by each player.

### Constructor
The contract constructor initializes the `admin` variable with the address of the contract deployer.

### Functions
The contract provides several functions for managing quests and player interactions, including:

- `createQuest`: Allows the admin to `create` a new quest. It takes in the parameters `title_`, `reward_`, and `numberOfRewards_` to initialize the quest's properties.
- `editQuest`: Allows the admin to `edit` an existing quest. It takes in the parameters `questId`, `newTitle`, `newReward`, and `newNumberOfRewards` to update the quest's properties.
- `deleteQuest`: Allows the admin to `delete` an existing quest. It takes in the `questId` as a parameter.
- `acceptQuest`: Allows the admin to `reward` or `approve` a submitted quest. It takes in the parameters `questId` and `player`. It checks if the player has previously submitted the quest and if there are players who have joined the quest. If there are remaining rewards, the player is rewarded, and the number of rewards left is reduced. Otherwise, the quest is approved for the player.
- `rejectQuest`: Allows the admin to `reject` a quest. It takes in the parameters `questId` and `player`. It checks if the player has previously submitted the quest and if there are players who have joined the quest. If the player was previouly APPROVED or REWARDED, it deducts the experience points and rewards that were previouly given for the quest, then updates the quest status to REJECTED.
- `joinQuest`: Allows a player to join a quest. It takes in the `questId` as a parameter and updates the player's quest status to JOINED.
- `submitQuest`: Allows a player to submit a quest. It takes in the `questId` as a parameter and updates the player's quest status to SUBMITTED.

### Modifiers
The contract includes two modifiers:
- `questExists`: Checks if a quest with the specified ID exists.
- `isAdmin`: Checks if the caller is the admin of the contract.

These functions and modifiers provide functionality for the admin to create, edit, and delete quests, as well as reward, approve, and reject quest submissions. Players can join and submit quests, and their rewards and quest statuses are tracked.


