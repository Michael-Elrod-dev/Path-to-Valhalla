# Name TBD

A 2D top-down action game built with Godot Engine (v4).

## Overview

Name TBD is a 2D, top-down, viking themed, rougelite game inspired by both [Hades](https://store.steampowered.com/app/1145360/Hades/) and [Hyper Light Drifter](https://store.steampowered.com/app/257850/Hyper_Light_Drifter/).

## Project Structure

```
game/
├── globals/                      # Singleton managers
│   ├── player_manager.gd         # Global player reference
│   └── level_manager.gd          # Scene management and level transitions
│
├── characters/                   # All game characters
│   ├── character.gd              # Base character class
│   │
│   ├── player/                   # Player implementation
│   │   ├── player.tscn           # Player scene
│   │   ├── sprites/              # Player sprite assets
│   │   ├── audio/attack/         # Player attack sound effects
│   │   └── scripts/
│   │       ├── player.gd
│   │       ├── player_camera.gd
│   │       ├── player_interactions.gd
│   │       ├── player_state_machine.gd
│   │       ├── player_state.gd
│   │       ├── player_state_idle.gd
│   │       ├── player_state_walk.gd
│   │       ├── player_state_attack.gd
│   │       └── player_state_stun.gd
│   │
│   └── enemies/                  # Enemy implementations
│       ├── scripts/
│       │   ├── enemy.gd
│       │   ├── enemy_state_machine.gd
│       │   ├── enemy_state.gd
│       │   ├── enemy_state_idle.gd
│       │   ├── enemy_state_wander.gd
│       │   ├── enemy_state_stun.gd
│       │   └── enemy_state_destroy.gd
│       └── slime/                # Slime enemy implementation
│           ├── slime.tscn
│           ├── sprites/
│           └── audio/
│
├── general_nodes/                # Reusable components
│   ├── state_machines/           # Base state machine system
│   │   ├── state_machine.gd      # Base state machine class
│   │   └── state.gd              # Base state class
│   ├── hitbox/                   # Damage dealing areas
│   │   ├── hitbox.gd
│   │   └── hitbox.tscn
│   └── hurtbox/                  # Damage detection areas
│       ├── hurtbox.gd
│       └── hurtbox.tscn
│
├── gui/                          # User interface systems
│   ├── hud/                      # Heads-up display
│   │   └── hud.tscn
│   ├── scene_transition/         # Scene transition animations
│   │   ├── scene_transition.gd
│   │   └── scene_transition.tscn
│   └── scripts/
│       └── healthbar.gd          # Health bar management
│
├── levels/                       # Level scenes and management
│   ├── 01/, 02/, 03/             # Individual level scenes
│   ├── level_transition.tscn     # Level transition trigger
│   ├── player_spawn.tscn         # Player spawn point
│   └── scripts/
│       ├── level.gd
│       ├── level_transition.gd
│       └── player_spawn.gd
│
└── tile_maps/                    # Tilemap and environment systems
    ├── environment.tscn          # Environment tilemap scene
    ├── level_01.tscn, level_02.tscn, level_03.tscn
    ├── level_tilemap.gd          # Tilemap management
    └── sprites/                  # Tileset sprite assets
```
