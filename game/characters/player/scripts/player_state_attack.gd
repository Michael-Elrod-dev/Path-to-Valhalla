# characters/player/scripts/player_state_attack.gd
class_name StateAttack
extends PlayerState
## Player attack state for melee combat.
##
## Handles attack animations, hurtbox activation, and mouse-directed
## attacking. Applies deceleration during the attack and returns to
## idle or walk state when complete.

@export var attack_sound = AudioStream
@export_range(1, 20, 0.5) var decelerate_speed: float = 5.0

var attacking: bool = false
var attack_direction: Vector2

@onready var dash: StateDash = $"../Dash"
@onready var walk: State = $"../Walk"
@onready var idle: State = $"../Idle"
@onready var attack: State = $"../Attack"
@onready var hurtbox: Hurtbox = %AttackHurtbox
@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"
@onready var audio: AudioStreamPlayer2D = $"../../Audio/AudioStreamPlayer2D"


func enter() -> void:
	var mouse_pos = player.get_global_mouse_position()
	var direction_to_mouse = (mouse_pos - player.global_position).normalized()
	attack_direction = player.get_nearest_direction(direction_to_mouse)
	player.cardinal_direction = attack_direction

	player.idle_walk_sprite.visible = false
	player.attack_sprite.visible = true
	player.update_animation("attack")
	player.get_node("Interactions").update_direction(attack_direction)

	animation_player.animation_finished.connect(end_attack)
	audio.stream = attack_sound
	audio.pitch_scale = randf_range(0.8, 1.1)
	audio.play()
	attacking = true

	await get_tree().create_timer(0.075).timeout
	if attacking:
		hurtbox.monitoring = true


func exit() -> void:
	player.idle_walk_sprite.visible = true
	player.attack_sprite.visible = false
	animation_player.animation_finished.disconnect(end_attack)
	attacking = false
	hurtbox.monitoring = false

	if player.direction != Vector2.ZERO:
		player.set_direction(player.direction)


func process(delta: float) -> State:
	player.velocity -= player.velocity * decelerate_speed * delta
	if attacking == false:
		if player.direction == Vector2.ZERO:
			return idle
		return walk
	return null


func physics(_delta: float) -> State:
	return null


func handle_input(_event: InputEvent) -> State:
	return null


func end_attack(_new_anim_name) -> void:
	attacking = false
