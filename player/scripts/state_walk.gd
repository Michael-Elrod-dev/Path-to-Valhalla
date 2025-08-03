class_name StateWalk extends State

@onready var idle: State = $"../Idle"
@onready var attack: StateAttack = $"../Attack"

@export var move_speed : float = 100.0

func enter() -> void:
	player.idle_walk_sprite.visible = true
	player.attack_sprite.visible = false
	player.update_animation("walk")

func exit() -> void:
	pass
	
func process(delta: float) -> State:
	if player.direction == Vector2.ZERO:
		return idle
	player.velocity = player.direction * move_speed
	if player.set_direction():
		player.update_animation("walk")
	
	return null
	
func physics(delta: float) -> State:
	return null
	
func handle_input(event: InputEvent) -> State:
	if event.is_action_pressed("attack"):
		return attack
	return null
