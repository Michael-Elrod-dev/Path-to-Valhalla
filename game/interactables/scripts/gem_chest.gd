class_name GemChest
extends Interactable
## Chest that can be opened by the player
##
## Provides the Player with gems

@export var loot_items: Array[String] = ["gems"]
@export var loot_amounts: Array[int] = [5]
@export var is_opened: bool = false


func _ready() -> void:
	super._ready()
	update_interaction_prompt()

	# If already opened, disable interaction
	if is_opened:
		can_interact = false


func open_chest() -> void:
	is_opened = true
	can_interact = false

	# Give loot to player
	for i in range(loot_items.size()):
		if i < loot_amounts.size():
			var item = loot_items[i]
			var amount = loot_amounts[i]
			PlayerManager.add_item(item, amount)


func _on_interact(_player: Player) -> void:
	if not is_opened:
		open_chest()
