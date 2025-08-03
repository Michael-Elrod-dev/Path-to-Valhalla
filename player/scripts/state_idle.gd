class_name StateIdle extends State

@onready var walk: State = $"../Walk"
@onready var attack: State = $"../Attack"

func enter() -> void:
	player.idle_walk_sprite.visible = true
	player.attack_sprite.visible = false
	player.update_animation("idle")

func exit() -> void:
	pass
	
func process(delta: float) -> State:
	if player.direction != Vector2.ZERO:
		return walk
	player.velocity = Vector2.ZERO
	return null
	
func physics(delta: float) -> State:
	return null
	
func handle_input(event: InputEvent) -> State:
	if event.is_action_pressed("attack"):
		return attack
	return null
