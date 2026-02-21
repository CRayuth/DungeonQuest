extends CanvasLayer

signal shown
signal hidden

# Node references
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var tab_container: TabContainer = $Control/TabContainer
@onready var inventory: Control = $Control/TabContainer/Inventory
@onready var item_description: Label = $Control/TabContainer/Inventory/ItemDescription

# System tab buttons
@onready var button_save: Button = $Control/TabContainer/System/VBoxContainer/Button_save
@onready var button_load: Button = $Control/TabContainer/System/VBoxContainer/Button_load
@onready var button_quit: Button = $Control/TabContainer/System/VBoxContainer/Button_quit

# Pause state
var is_paused: bool = false

func _ready() -> void:
	hide_pause_menu()

	if button_save:
		button_save.pressed.connect(_on_save_pressed)

	if button_load:
		button_load.pressed.connect(_on_load_pressed)

	if button_quit:
		button_quit.pressed.connect(_on_quit_pressed)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		if is_paused:
			hide_pause_menu()
		else:
			show_pause_menu()

		get_viewport().set_input_as_handled()

func show_pause_menu() -> void:
	get_tree().paused = true
	visible = true
	is_paused = true
	shown.emit()

func hide_pause_menu() -> void:
	get_tree().paused = false
	visible = false
	is_paused = false
	hidden.emit()

func _on_save_pressed() -> void:
	if not is_paused:
		return

	if SaveManager.has_method("save_game"):
		SaveManager.save_game()

	hide_pause_menu()

func _on_load_pressed() -> void:
	if not is_paused:
		return

	if SaveManager.has_method("load_game"):
		SaveManager.load_game()

	hide_pause_menu()

func _on_quit_pressed() -> void:
	get_tree().quit()


func update_item_description(new_text: String) -> void:
	if item_description:
		item_description.text = new_text

func play_audio(audio: AudioStream) -> void:
	if audio_stream_player_2d:
		audio_stream_player_2d.stream = audio
		audio_stream_player_2d.play()
