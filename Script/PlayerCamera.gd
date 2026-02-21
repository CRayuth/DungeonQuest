class_name PlayerCamera
extends Camera2D

func _ready() -> void:
	LevelManager.TileMapBoundsChanged.connect(UpdateLimits)

	# Apply immediately if bounds already exist
	if not LevelManager.current_tilemap_bounds.is_empty():
		UpdateLimits(LevelManager.current_tilemap_bounds)

func UpdateLimits(bounds: Array[Vector2]) -> void:
	if bounds.is_empty():
		return

	limit_left = int(bounds[0].x)
	limit_top = int(bounds[0].y)
	limit_right = int(bounds[1].x)
	limit_bottom = int(bounds[1].y)
