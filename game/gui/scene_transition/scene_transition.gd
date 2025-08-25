# gui/scene_transition/scene_transition.gd
extends CanvasLayer
## Manages fade transitions between scenes.
##
## Provides fade in/out animations for smooth scene changes.
## Used by the LevelManager for level transitions.

@onready var animation_player: AnimationPlayer = $Control/AnimationPlayer


func fade_out() -> bool:
	animation_player.play("fade_out")
	await animation_player.animation_finished
	return true


func fade_in() -> bool:
	animation_player.play("fade_in")
	await animation_player.animation_finished
	return true
