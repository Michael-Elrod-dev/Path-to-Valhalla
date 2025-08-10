class_name ResourceDisplay extends VBoxContainer

@export var resources_to_display: Array[String] = ["gems"]

@export_group("Layout Settings")
@export var min_width: int = 5
@export var padding: int = 0
@export var resource_spacing: int = 4
@export var icon_spacing: int = 0

@export_group("Icon Settings")
@export var icon_size: Vector2 = Vector2(24, 24)

@export_group("Font Settings")
@export var font_size: int = 16
@export var font_color: Color = Color.WHITE

var resource_rows: Dictionary = {}

func _ready() -> void:
	add_theme_constant_override("separation", resource_spacing)	
	create_all_resource_displays()
	PlayerManager.resource_changed.connect(_on_resource_changed)
	await get_tree().process_frame
	update_all_displays()

# Rest of your functions stay the same...
func create_all_resource_displays() -> void:
	for child in get_children():
		child.queue_free()
	resource_rows.clear()
	for resource_id in resources_to_display:
		create_resource_row(resource_id)

func create_resource_row(resource_id: String) -> void:
	var resource_data = ResourceManager.get_resource_data(resource_id)
	if not resource_data:
		return
	
	var h_box = HBoxContainer.new()
	h_box.name = resource_id.capitalize() + "Row"
	h_box.mouse_filter = Control.MOUSE_FILTER_PASS
	h_box.focus_mode = Control.FOCUS_NONE
	h_box.add_theme_constant_override("separation", icon_spacing)
	
	var icon = TextureRect.new()
	icon.name = "Icon"
	icon.texture = resource_data.texture
	icon.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
	icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	icon.custom_minimum_size = icon_size
	icon.size = icon_size
	icon.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	icon.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	
	var count_label = Label.new()
	count_label.name = "Count"
	count_label.text = "0"
	count_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	count_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	count_label.add_theme_font_size_override("font_size", font_size)
	count_label.add_theme_color_override("font_color", font_color)
	h_box.add_child(icon)
	h_box.add_child(count_label)
	add_child(h_box)
	
	resource_rows[resource_id] = {
		"container": h_box,
		"icon": icon,
		"count_label": count_label,
		"resource_data": resource_data
	}
	h_box.mouse_entered.connect(_on_resource_hover_entered.bind(resource_id))
	h_box.mouse_exited.connect(_on_resource_hover_exited)

func _on_resource_changed(item_id: String, new_count: int) -> void:
	if not resource_rows.has(item_id):
		return
	
	var row = resource_rows[item_id]
	var current_text = row.count_label.text
	var new_text = str(new_count)
	
	if current_text != new_text:
		row.count_label.text = new_text
		update_count_width(row.count_label)

func update_resource_display(resource_id: String) -> void:
	if not resource_rows.has(resource_id):
		return
	
	var current_count = PlayerManager.get_item_count(resource_id)
	var row = resource_rows[resource_id]
	var current_text = row.count_label.text
	var new_text = str(current_count)
	
	if current_text != new_text:
		row.count_label.text = new_text
		update_count_width(row.count_label)

func update_count_width(count_label: Label) -> void:
	var font = count_label.get_theme_font("font")
	var font_size_actual = count_label.get_theme_font_size("font_size")
	var text_width = font.get_string_size(count_label.text, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size_actual).x
	
	var new_width = max(min_width, text_width + padding * 2)
	count_label.custom_minimum_size.x = new_width

func update_all_displays() -> void:
	for resource_id in resources_to_display:
		update_resource_display(resource_id)

func _on_resource_hover_entered(resource_id: String) -> void:
	if resource_rows.has(resource_id):
		var resource_data = resource_rows[resource_id].resource_data
		TooltipManager.show_tooltip(resource_data.name, resource_data.description)

func _on_resource_hover_exited() -> void:
	TooltipManager.hide_tooltip()
