# characters/enemies/scripts/enemy_state.gd
class_name EnemyState
extends State
## Base class for enemy state machine states.
##
## Provides shared references to the enemy and state machine
## for all enemy states to access.

var enemy: Enemy
var state_machine: EnemyStateMachine
