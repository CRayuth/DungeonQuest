extends Control
@onready var main_buttons: VBoxContainer = $MainButtons
@onready var continue_button: Button = $MainButtons/continue_game
@onready var setting_background: Panel = $Setting_Background
@onready var music_control: HSlider = $Setting_Background/MusicControl
@onready var music_mute_button: Button = $Setting_Background/MusicMuteButton

func _ready():
	# this is to open the Mainbutton and close the setting background
	main_buttons.visible = true
	setting_background.visible = false

	# Update mute button states
	update_mute_buttons()

	# Handle Audio Manager if it exists in tree as a Singleton
	if get_tree().root.has_node("AudioManager"):
		pass # Logic for AudioManager can go here

	if FileAccess.file_exists(SaveManager.SAVE_PATH):
		continue_button.disabled = false
	else:
		continue_button.disabled = true

	# Hide gameplay elements while in the main menu
	if PlayerManager and PlayerManager.player:
		PlayerManager.player.visible = false
		PlayerManager.player.process_mode = Node.PROCESS_MODE_DISABLED
	if get_tree().root.has_node("PlayerHud"):
		var hud = get_tree().root.get_node("PlayerHud")
		hud.visible = false
		hud.process_mode = Node.PROCESS_MODE_DISABLED
		
	# Fix camera offset by spawning a temporary static camera centered on the 480x270 viewport
	var menu_camera = Camera2D.new()
	menu_camera.position = Vector2(240, 135)
	add_child(menu_camera)
	menu_camera.make_current()

func _restore_gameplay_elements() -> void:
	if PlayerManager and PlayerManager.player:
		PlayerManager.player.visible = true
		PlayerManager.player.process_mode = Node.PROCESS_MODE_INHERIT
		if PlayerManager.player.has_node("Camera2D"):
			PlayerManager.player.get_node("Camera2D").make_current()
	if get_tree().root.has_node("PlayerHud"):
		var hud = get_tree().root.get_node("PlayerHud")
		hud.visible = true
		hud.process_mode = Node.PROCESS_MODE_INHERIT

func update_mute_buttons():
	if get_tree().root.has_node("SettingsManager"):
		var settings = get_tree().root.get_node("SettingsManager")
		if settings.has_method("is_music_muted"):
			music_mute_button.text = "Mute" if not settings.is_music_muted() else "Unmute"
			
		# Also update the volume controls to reflect mute state
		if music_control:
			music_control.update_volume(music_control.value)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("down"):
		print("Down")


func _on_new_game_pressed() -> void:
	if PlayerManager:
		PlayerManager.player_spawned = false # Force the player_spawn script to reset their position when World loads
	transition_to_scene("res://World.tscn")

func transition_to_scene(scene_path: String):
	_restore_gameplay_elements()
	
	# Change scene
	get_tree().change_scene_to_file(scene_path)



func _on_continue_game_pressed() -> void:
	if FileAccess.file_exists(SaveManager.SAVE_PATH):
		_restore_gameplay_elements()
		
		# Let SaveManager load and transition
		SaveManager.load_game()
	else:
		push_error("Failed to load game: No save file found.")

func _on_setting_game_pressed() -> void:
	# this is to open the setting background and close the main button
	main_buttons.visible = false
	setting_background.visible = true
	update_mute_buttons()

# this function is to press to go back to the starting game menu
func _on_back_pressed() -> void:
	_ready()

func _on_exit_game_pressed() -> void:
	get_tree().quit()

func _on_music_mute_button_pressed() -> void:
	if get_tree().root.has_node("SettingsManager"):
		var settings = get_tree().root.get_node("SettingsManager")
		if settings.has_method("toggle_music_mute"):
			settings.toggle_music_mute()
			update_mute_buttons()
