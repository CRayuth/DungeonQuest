class_name LevelTileMapLayer extends TileMapLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	LevelManager.ChangeTilemapBounds(GetTilemapBounds())
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func GetTilemapBounds() -> Array[Vector2]:
	var bounds : Array[Vector2] = []
	bounds.append(
		Vector2(get_used_rect().position * rendering_quadrant_size)
	)
	bounds.append(
		Vector2(get_used_rect().end * rendering_quadrant_size )
	)
	return bounds
