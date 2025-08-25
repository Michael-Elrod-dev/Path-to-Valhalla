# resources/scripts/resource_data.gd
class_name ResourceData
extends Resource
## Data container for collectible game resources.
##
## Defines properties for items like gems, coins, or other collectibles
## including display name, ID, description, and icon texture.

@export var name: String = ""
@export var resource_id: String = ""
@export_multiline var description: String = ""
@export var texture: Texture2D
