class_name InventoryData
extends Resource

@export var slots: Array[SlotData]

func _init() -> void:
	connect_slots()

func add_item(item: ItemData, count: int = 1) -> bool:
	for s in slots: 
		if s:
			if s.item_data == item:
				s.quantity += count
				return true
				
	for i in range(slots.size()):
		if slots[i] == null:
			var new = SlotData.new()
			new.item_data = item
			slots[i] = new
			new.changed.connect(slot_changed)
			new.quantity = count
			return true
		
	return false

func swap_items(index1: int, index2: int) -> void:
	if index1 < 0 or index1 >= slots.size() or index2 < 0 or index2 >= slots.size():
		return
	if index1 == index2:
		return
		
	var tmp = slots[index1]
	slots[index1] = slots[index2]
	slots[index2] = tmp
	emit_changed()

func connect_slots() -> void:
	for s in slots:
		if s:
			s.changed.connect(slot_changed)
			
func slot_changed() -> void:
	for s in slots:
		if s: 
			if s.quantity < 1:
				s.changed.disconnect(slot_changed)
				var index = slots.find(s)
				slots[index] = null
	emit_changed()

func get_item_held_quantity(item: ItemData) -> int:
	var total = 0
	for s in slots:
		if s and s.item_data == item:
			total += s.quantity
	return total

func use_item(item: ItemData, amount: int) -> bool:
	if get_item_held_quantity(item) < amount:
		return false
	
	var remaining = amount
	for s in slots:
		if s and s.item_data == item:
			if s.quantity >= remaining:
				s.quantity -= remaining
				return true
			else:
				remaining -= s.quantity
				s.quantity = 0
	return true

func get_save_data() -> Array:
	var item_save: Array = []
	for i in range(slots.size()):
		item_save.append(item_to_save(slots[i]))
	return item_save
	
func item_to_save(slot: SlotData) -> Dictionary:
	var result = { "item": "", "quantity": 0 }
	if slot != null: 
		result.quantity = slot.quantity
		if slot.item_data != null:
			result.item = slot.item_data.resource_path
	return result

func parse_save_data(save_data : Array) -> void:
	var array_size = slots.size()
	slots.clear()
	slots.resize(array_size)
	
	for i in save_data.size():
		slots[i] = item_from_save(save_data[i])
	connect_slots() 
	
func item_from_save(save_object : Dictionary) -> SlotData:
	if save_object.item == "":
		return null
	var new_slot : SlotData = SlotData.new()
	new_slot.item_data = load(save_object.item)
	new_slot.quantity = int (save_object.quantity)
	return new_slot
