# Trials of Odin

A 2D top-down action game built with Godot Engine (v4).

## Overview

Trials of Odin is a 2D top-down game featuring player combat, enemy AI, and a state machine architecture with much more to come.

## Project Structure

```
Trials-of-Odin/
├── globals/                      # Singleton managers
│   ├── player_manager.gd         # Global player reference
│   └── level_manager.gd          # Level bounds management
│
├── characters/                   # All game characters
│   ├── character.gd              # Base character class
│   │
│   ├── player/                   # Player implementation
│   │   └── scripts/
│   │       ├── player.gd
│   │       ├── player_camera.gd
│   │       ├── player_interactions.gd
│   │       ├── player_state_machine.gd
│   │       ├── player_state.gd
│   │       └── player states (idle, walk, attack)
│   │
│   └── enemies/                  # Enemy implementations
│       └── scripts/
│           ├── enemy.gd
│           ├── enemy_state_machine.gd
│           ├── enemy_state.gd
│           └── enemy states (idle, wander, stun, destroy)
│
├── general_nodes/                # Reusable components
│   ├── state_machine/            # Base state machine system
│   │   ├── state_machine.gd      # Base state machine class
│   │   └── state.gd              # Base state class
│   ├── hitbox/                   # Damage detection areas
│   │   └── hitbox.gd
│   └── hurtbox/                  # Damage dealing areas
│       └── hurtbox.gd
│
└── tile_maps/                    # Level and tilemap systems
	└── level_tilemap.gd
```
