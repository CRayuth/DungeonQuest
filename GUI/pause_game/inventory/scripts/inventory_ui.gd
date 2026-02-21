class_name InventoryUI
extends Control

const INVENTORY_SLOT = preload("res://GUI/pause_game/inventory/inventory_slot.tscn")

var focus_index: int = 0
@export var data: InventoryData

func _ready() -> void:
	PauseMenu.shown.connect(update_inventory)
	PauseMenu.hidden.connect(clear_inventory)
	clear_inventory()
	if data:
		data.changed.connect(on_inventory_changed)

func clear_inventory() -> void:
	for c in get_children():
		c.queue_free()

func update_inventory() -> void:
	if data == null:
		return
		
	clear_inventory()

	for i in range(data.slots.size()):
		var s = data.slots[i]
		var new_slot = INVENTORY_SLOT.instantiate()
		add_child(new_slot)
		new_slot.slot_data = s
		new_slot.slot_index = i
		new_slot.inventory_data = data
		new_slot.focus_entered.connect(item_focused)

	await get_tree().process_frame

	if get_child_count() > 0:
		focus_index = clamp(focus_index, 0, get_child_count() - 1)
		get_child(focus_index).grab_focus()

func item_focused() -> void:
	for i in range(get_child_count()):
		if get_child(i).has_focus():
			focus_index = i
			return

func on_inventory_changed() -> void:
	clear_inventory()
	update_inventory()
