extends Node
const SAVE_PATH = "user://save.sav"

signal game_loaded
signal game_saved

var current_save : Dictionary = {
	scene_path = "",
	player = {
		hp = 1,
		max_hp = 1,
		pos_x = 0,
		pos_y = 0
	},
	items = [],
	persistence = [],
	quests = [],
}

func save_game() -> void:
	update_player_data()
	update_item_data()
	update_scene_path()
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	var save_json = JSON.stringify(current_save)
	file.store_line(save_json)
	game_saved.emit()
	print("Game saved to: ", current_save.scene_path)

func load_game() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		print("No save file found.")
		return

	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	var json := JSON.new()
	json.parse(file.get_line())

	var save_dict : Dictionary = json.get_data() as Dictionary
	current_save = save_dict

	# Restore inventory
	PlayerManager.INVENTORY_DATA.parse_save_data(current_save.items)

	# Change to the saved scene, then restore player state
	var saved_scene : String = current_save.scene_path
	if saved_scene == "":
		saved_scene = "res://World.tscn"
		
	if get_tree().current_scene and get_tree().current_scene.scene_file_path != saved_scene:
		get_tree().change_scene_to_file(saved_scene)
		# Wait one frame for the new scene to be fully ready
		await get_tree().process_frame
		
	_restore_player()

	game_loaded.emit()
	print("Game loaded. Scene: ", saved_scene)

func _restore_player() -> void:
	var p : Player = PlayerManager.player
	if p == null:
		return
	p.hp      = current_save.player.hp
	p.max_hp  = current_save.player.max_hp
	p.global_position = Vector2(
		current_save.player.pos_x,
		current_save.player.pos_y
	)
	# Notify HUD to refresh HP display
	p.healthChanged.emit()

func update_player_data() -> void:
	var p : Player = PlayerManager.player
	current_save.player.hp     = p.hp
	current_save.player.max_hp = p.max_hp
	current_save.player.pos_x  = p.global_position.x
	current_save.player.pos_y  = p.global_position.y

func update_scene_path() -> void:
	var p : String = ""
	for c in get_tree().root.get_children():
		if c.scene_file_path != "":
			p = c.scene_file_path
	current_save.scene_path = p

func update_item_data() -> void:
	current_save.items = PlayerManager.INVENTORY_DATA.get_save_data()
