# characters/player/scripts/player_state_stun.gd
class_name StateStun
extends PlayerState

@export var animation_name: String = "stun"
@export var knockback_speed: float = 200.0
@export var decelerate_speed: float = 10.0
@export var invulnerable_duration: float = 1.0

@onready var idle: PlayerState = $"../Idle"

var hurtbox: Hurtbox
var direction: Vector2
var next_state: State = null


func initialize() -> void:
	player.damaged.connect(on_player_damaged)


func enter() -> void:
	player.animation_player.animation_finished.connect(on_animation_finished)
	direction = player.global_position.direction_to(hurtbox.global_position)
	player.velocity = direction * -knockback_speed
	player.set_direction()
	player.update_animation(animation_name)
	player.make_invulnerable(invulnerable_duration)
	player.effect_animation_player.play("damaged")


func exit() -> void:
	next_state = null
	player.animation_player.animation_finished.disconnect(on_animation_finished)


func process(delta: float) -> State:
	player.velocity -= player.velocity * decelerate_speed * delta
	return next_state


func physics(_delta: float) -> State:
	return null


func handle_input(_event: InputEvent) -> State:
	return null


func on_player_damaged(hurt_box: Hurtbox) -> void:
	hurtbox = hurt_box
	state_machine.change_state(self)


func on_animation_finished(_animation: String) -> void:
	next_state = idle