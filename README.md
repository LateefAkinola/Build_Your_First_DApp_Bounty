# Build_Your_First_DApp_Bounty
The `StackUp` contract is a smart contract written in Solidity. It provides functionality for managing quests and player interactions within a game.

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

- `createQuest`: Allows the admin to create a new quest.
- `editQuest`: Allows the admin to edit an existing quest.
- `deleteQuest`: Allows the admin to delete an existing quest.
- `acceptQuest`: Allows the admin to reward or approve a submitted quest.
- `rejectQuest`: Allows the admin to reject a quest.
- `joinQuest`: Allows a player to join a quest.
- `submitQuest`: Allows a player to submit a quest.

### Modifiers
The contract includes two modifiers:
- `questExists`: Checks if a quest with the specified ID exists.
- `isAdmin`: Checks if the caller is the admin of the contract.

These functions and modifiers provide the necessary functionality for managing quests and player interactions within the game.




Here's the explanation of the code:

1. Enum `PlayerQuestStatus`: This enum defines the possible statuses of a player's quest, such as NOT_JOINED, JOINED, SUBMITTED, REWARDED, APPROVED, and REJECTED.

2. Struct `Quest`: This struct represents a quest and includes properties like `questId`, `numberOfPlayers`, `title`, `reward`, `numberOfRewards`, and `numberOfRewardsLeft`. The `numberOfRewardsLeft` property is used to track the number of rewards remaining for a quest.

3. Struct `PlayerRewards`: This struct stores information about a player's rewards, including `totalEarnings` and `totalExp`.

4. Public variables:
   - `admin`: Stores the address of the contract's admin.
   - `nextQuestId`: Represents the ID of the next quest to be created.
   - `quests`: Maps quest IDs to their corresponding `Quest` structs.
   - `playerQuestStatuses`: Maps player addresses to a mapping of quest IDs to their `PlayerQuestStatus`.
   - `playerRewards`: Maps player addresses to their `PlayerRewards` struct.

5. Constructor: Initializes the `admin` variable with the address of the contract deployer.

6. Function `createQuest`: Allows the admin to create a new quest. It takes in parameters like `title_`, `reward_`, and `numberOfRewards_` to initialize the quest's properties.

7. Function `editQuest`: Allows the admin to edit an existing quest. It takes in parameters like `questId`, `newTitle`, `newReward`, and `newNumberOfRewards` to update the quest's properties.

8. Function `deleteQuest`: Allows the admin to delete an existing quest. It takes in the `questId` as a parameter.

9. Function `acceptQuest`: Allows the admin to reward or approve a submitted quest. It takes in parameters like `questId` and `player`. It checks if the player has previously submitted the quest and if there are players who have joined the quest. If there are remaining rewards, the player is rewarded, and the number of rewards left is reduced. Otherwise, the quest is approved for the player.

10. Function `rejectQuest`: Allows the admin to reject a quest. It takes in parameters like `questId` and `player`. It checks if the player has previously submitted the quest and if there are players who have joined the quest. Depending on the player's quest status (APPROVED or REWARDED), it deducts the rewards or experience points and updates the quest status to REJECTED.

11. Function `joinQuest`: Allows a player to join a quest. It takes in the `questId` as a parameter and updates the player's quest status to JOINED.

12. Function `submitQuest`: Allows a player to submit a quest. It takes in the `questId` as a parameter and updates the player's quest status to SUBMITTED.

13. Modifiers:
    - `questExists`: Checks if a quest with the specified ID exists.
    - `isAdmin`: Checks if the caller is the admin of the contract.

These functions and modifiers provide functionality for the admin to create, edit, and delete quests, as well as reward, approve, and reject quest submissions. Players can join and submit quests, and their rewards and quest statuses are tracked.


