# resources/scripts/dialog_data.gd
class_name DialogData
extends Resource
## Data container for NPC dialog conversations.
##
## Defines dialog text and character information.
## Supports multi-page dialogs.

@export var character_name: String = ""
@export var character_portrait: Texture2D
@export_multiline var dialog_pages: Array[String] = []

@export_group("Behavior")
@export var can_repeat: bool = true
@export var dialog_speed: float = 0.05
