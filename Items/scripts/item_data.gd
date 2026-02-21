class_name ItemData extends Resource

@export var name: String = ""
@export_multiline var description: String = ""
@export var texture: Texture2D
@export_category("Shop")
@export var cost: int = 0

@export_category("Item Use Effects")
@export var effects: Array[ItemEffect]

func use() -> bool:
	if effects.is_empty():
		return false
	
	for e in effects:
		if e == null:
			continue
		e.use()
	
	return true
