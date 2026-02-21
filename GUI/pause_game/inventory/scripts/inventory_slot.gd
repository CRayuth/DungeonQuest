class_name InventorySlotUI extends Button

var slot_data: SlotData: 
	set = set_slot_data

var slot_index: int = -1
var inventory_data: InventoryData = null

@onready var texture_rect: TextureRect = $TextureRect
@onready var label: Label = $Label


func _ready() -> void:
	texture_rect.texture = null
	label.text = ""
	focus_entered.connect(item_focused)
	focus_exited.connect(item_unfocused)
	pressed.connect(item_pressed)
	
func set_slot_data(value: SlotData)-> void:
	slot_data = value
	if slot_data == null:
		return
		
	texture_rect.texture = slot_data.item_data.texture
	label.text = str(slot_data.quantity)
	
func item_focused()-> void: 
	if slot_data != null:
		if slot_data.item_data != null:
			PauseMenu.update_item_description(slot_data.item_data.description)
	
func item_unfocused()-> void:
	PauseMenu.update_item_description("")
	pass
	
func item_pressed() -> void:
	if slot_data:
		if slot_data.item_data:
			var was_used = slot_data.item_data.use()
			if was_used == false:
				return
			slot_data.quantity -= 1
			label.text = str(slot_data.quantity)

func _get_drag_data(_at_position: Vector2) -> Variant:
	if not slot_data or not slot_data.item_data:
		return null
		
	var drag_preview = TextureRect.new()
	drag_preview.texture = slot_data.item_data.texture
	drag_preview.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	drag_preview.custom_minimum_size = Vector2(32, 32)
	drag_preview.modulate = Color(1, 1, 1, 0.7)
	
	set_drag_preview(drag_preview)
	
	return {
		"type": "inventory_slot",
		"index": slot_index,
		"inventory_data": inventory_data
	}

func _can_drop_data(_at_position: Vector2, drag_data: Variant) -> bool:
	if typeof(drag_data) == TYPE_DICTIONARY and drag_data.has("type") and drag_data["type"] == "inventory_slot":
		if drag_data.has("inventory_data") and drag_data["inventory_data"] == inventory_data:
			return true
	return false

func _drop_data(_at_position: Vector2, drag_data: Variant) -> void:
	var from_index = drag_data["index"]
	if from_index != slot_index:
		inventory_data.swap_items(from_index, slot_index)
