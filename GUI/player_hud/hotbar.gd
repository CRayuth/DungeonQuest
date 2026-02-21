class_name Hotbar
extends HBoxContainer

const INVENTORY_SLOT = preload("res://GUI/pause_game/inventory/inventory_slot.tscn")

var slots: Array = []

func _ready() -> void:
	if PlayerManager.INVENTORY_DATA:
		PlayerManager.INVENTORY_DATA.changed.connect(update_hotbar)
		update_hotbar()

func update_hotbar() -> void:
	for c in get_children():
		c.queue_free()
	slots.clear()
	
	var data = PlayerManager.INVENTORY_DATA
	var hotbar_size = min(5, data.slots.size())
	for i in range(hotbar_size):
		var s = data.slots[i]
		var new_slot = INVENTORY_SLOT.instantiate()
		add_child(new_slot)
		new_slot.slot_data = s
		new_slot.slot_index = i
		new_slot.inventory_data = data
		slots.append(new_slot)

func _unhandled_input(event: InputEvent) -> void:
	# Ignore input if paused
	if get_tree().paused:
		return
		
	if event is InputEventKey and event.pressed and not event.echo:
		match event.keycode:
			KEY_1: use_slot(0)
			KEY_2: use_slot(1)
			KEY_3: use_slot(2)
			KEY_4: use_slot(3)
			KEY_5: use_slot(4)

func use_slot(index: int) -> void:
	if index < slots.size():
		var slot_ui = slots[index]
		if slot_ui.slot_data and slot_ui.slot_data.item_data:
			slot_ui.item_pressed()
