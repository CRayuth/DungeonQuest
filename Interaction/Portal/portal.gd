extends Area2D

@export_file("*.tscn") var target_scene: String = ""
@export var current_scene_name: String = ""  # Store which scene this portal is in

var player_nearby: bool = false
var can_interact: bool = true

@onready var prompt_label = $PromptLabel

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	
	if prompt_label:
		prompt_label.visible = false
	
	if target_scene == "":
		push_warning("Portal has no target scene set!")
	
	# Auto-detect current scene if not set
	if current_scene_name == "":
		current_scene_name = get_tree().current_scene.scene_file_path

func _on_body_entered(body: Node2D) -> void:
	if body is Player or body.name == "Player":
		player_nearby = true
		show_prompt()

func _on_body_exited(body: Node2D) -> void:
	if body is Player or body.name == "Player":
		player_nearby = false
		hide_prompt()

func _process(_delta: float) -> void:
	if player_nearby and can_interact and Input.is_action_just_pressed("interact"):
		use_portal()

func use_portal() -> void:
	if target_scene == "":
		print("Error: No target scene set for portal!")
		return
	
	can_interact = false
	hide_prompt()
	
	PlayerManager.previous_scene = current_scene_name
	PlayerManager.player_spawned = false
	
	get_tree().change_scene_to_file(target_scene)

func show_prompt() -> void:
	if prompt_label:
		prompt_label.visible = true

func hide_prompt() -> void:
	if prompt_label:
		prompt_label.visible = false
