class_name Player extends CharacterBody2D

@onready var state_machine: PlayerStateMachine = $StateMachine
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var idle_walk_sprite: Sprite2D = $Idle_Walk
@onready var attack_sprite: Sprite2D = $Attack

signal direction_changed(new_direction: Vector2)

var cardinal_direction: Vector2 = Vector2.DOWN
var direction: Vector2 = Vector2.ZERO

func _ready() -> void:
	state_machine.initialize(self)
	
func _process(delta: float) -> void:
	direction = Vector2(
		Input.get_axis("move_left", "move_right"), 
		Input.get_axis("move_up", "move_down")
		).normalized()

func _physics_process(delta: float) -> void:    
	move_and_slide()

func set_direction() -> bool:
	var new_direction: Vector2 = cardinal_direction
	if direction == Vector2.ZERO:
		return false
	
	if direction.x != 0:
		new_direction = Vector2.LEFT if direction.x < 0 else Vector2.RIGHT
	elif direction.y != 0:
		if direction.y < 0:
			new_direction = Vector2.UP
		else:
			new_direction = Vector2.DOWN
	
	if new_direction == cardinal_direction:
		return false
		
	cardinal_direction = new_direction
	
	# Update both sprites for direction
	update_sprite_direction()
	direction_changed.emit(new_direction)
	
	return true
	
func update_sprite_direction():
	if cardinal_direction == Vector2.LEFT or cardinal_direction == Vector2.RIGHT:
		var scale_x = -1 if cardinal_direction == Vector2.LEFT else 1
		idle_walk_sprite.scale.x = scale_x
		attack_sprite.scale.x = scale_x
		if cardinal_direction == Vector2.LEFT:
			attack_sprite.position.x = -10
		else:
			attack_sprite.position.x = 0
	
func update_animation(state: String):
	animation_player.play(state + "_" + convert_direction())
	
func convert_direction() -> String:
	if cardinal_direction == Vector2.DOWN:
		return "side"
	elif cardinal_direction == Vector2.UP:
		return "side"
	else:
		return "side"
