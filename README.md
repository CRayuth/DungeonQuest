# Dungeon Quest - Godot RPG

Dungeon Quest is a 2D action RPG built with Godot 4. The game features classic dungeon crawling gameplay with combat, exploration, and progression systems.

## Features

- **Combat System**: Real-time combat with light attacks, heavy attacks, and special moves
- **Character Progression**: Health management with potions and upgrades
- **Enemy AI**: Various enemy types with state-based AI behaviors
- **Level Transitions**: Seamless movement between different areas and dungeons
- **Save System**: Persistent saving and loading of game progress
- **Inventory Management**: Collect and use items during gameplay
- **Audio System**: Dynamic music and sound effects

## Game Mechanics

### Controls
- Movement: WASD or Arrow Keys
- Light Attack: E
- Heavy Attack: R
- Dash: Spacebar
- Interact: F
- Pause Menu: Escape

### Combat
The game features a dynamic combat system where players can:
- Perform light and heavy attacks
- Dash to avoid enemy attacks
- Take damage when colliding with enemies
- Use healing items to restore health

### Enemies
- **Slimes**: Basic enemies that chase and attack the player
- **Bosses**: More challenging enemies with unique abilities
- Enemy AI uses state machines for different behaviors (idle, chase, attack, wander)

### Items & Inventory
- Collect various items during gameplay
- Use healing potions to restore health
- Different weapon upgrades available
- Inventory system with persistent storage

## Architecture

### Core Systems
- **Player Controller**: Manages player movement, animations, and state management
- **State Machines**: Both player and enemies use state machines for behavior
- **Hit/Hurt Boxes**: Collision-based damage system
- **Autoloads**: Global managers for player, save data, levels, and UI

### Global Managers
- `PlayerManager`: Handles player spawning and positioning
- `SaveManager`: Manages game saves and loading
- `LevelManager`: Tracks level bounds and transitions
- `PlayerStats`: Runtime stat modifications from items

### Scene Structure
- **Main Menu**: Start screen with options for new game, continue, settings, and exit
- **World Scene**: Main gameplay area with enemies and interactive elements
- **Player HUD**: Heads-up display showing health and other vital information
- **Pause Menu**: In-game menu for saving, loading, and quitting


## File Structure

```
├── 00_Globals/          # Autoload singletons
├── Enemy/              # Enemy classes, AI, and assets
├── GUI/                # User interface scenes and scripts
├── GeneralNodes/       # Reusable game components (HitBox, HurtBox)
├── Interaction/        # Interactive elements (Portals)
├── Items/              # Item system and effects
├── Levels/             # Level-specific scripts and scenes
├── Map/                # Tilemaps and map assets
├── Player/             # Player character and animations
├── Script/             # Player state machine and core logic
└── ...
```


## How to Play

1. Clone or download the project
2. Open with Godot 4
3. Run the project from the main menu scene
4. Select "New Game" to start
5. Explore the dungeon, fight enemies, and collect items!

## Images of Gameplay 

![StartGame](/markdownDes/mainmenu.jpg)
![Inventory](/markdownDes/inventory.jpg)
![Shop](/markdownDes/shop.jpg)
![Enemy](/markdownDes/enemyL2.jpg)
![System](/markdownDes/System.jpg)
![Quest](/markdownDes/Quest.jpg)
![Boss](/markdownDes/Boss.jpg)