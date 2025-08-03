class_name StateAttack extends State

@onready var attack: State = $"../Attack"
@onready var walk: State = $"../Walk"
@onready var idle: State = $"../Idle"
@onready var hurtbox: Hurtbox = $"../../Interactions/Hurtbox"
@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"
@onready var audio: AudioStreamPlayer2D = $"../../Audio/AudioStreamPlayer2D"

@export var attack_sound = AudioStream
@export_range(1, 20, 0.5) var decelerate_speed : float = 5.0

var attacking : bool = false

func enter() -> void:
	player.idle_walk_sprite.visible = false
	player.attack_sprite.visible = true
	player.update_animation("attack")
	animation_player.animation_finished.connect(end_attack)
	audio.stream = attack_sound
	audio.pitch_scale = randf_range(0.8, 1.1)
	audio.play()
	attacking = true
	
	await get_tree().create_timer(0.075).timeout
	hurtbox.monitoring = true

func exit() -> void:
	player.idle_walk_sprite.visible = true
	player.attack_sprite.visible = false
	animation_player.animation_finished.disconnect(end_attack)
	attacking = false
	hurtbox.monitoring = false
	
func process(delta: float) -> State:
	player.velocity -= player.velocity * decelerate_speed * delta
	if attacking == false:
		if player.direction == Vector2.ZERO:
			return idle
		return walk
	return null
	
func physics(delta: float) -> State:
	return null
	
func handle_input(event: InputEvent) -> State:
	return null

func end_attack(_newAnimName) -> void:
	attacking = false
