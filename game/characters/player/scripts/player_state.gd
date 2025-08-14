# characters/player/scripts/player_state.gd
class_name PlayerState
extends State
## Base class for player state machine states.
##
## Provides shared references to the player and state machine
## for all player states to access.

static var player: Player
static var state_machine: PlayerStateMachine