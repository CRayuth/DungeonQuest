extends CanvasLayer

@onready var hp_bar: ProgressBar = $HpBar
@onready var stamina_bar: ProgressBar = $StaminaBar
@onready var bgm: AudioStreamPlayer2D = $BGM

@export var normal_music: AudioStream
@export var boss_music: AudioStream
@export var victory_music: AudioStream

var current_music: AudioStream = null
var boss_defeated: bool = false

func _ready():
	_wait_for_player()
	_connect_to_boss()

func _wait_for_player() -> void:
	while not PlayerManager.player_spawned or not PlayerManager.player:
		await get_tree().process_frame
	
	var player = PlayerManager.player
	if player and hp_bar:
		player.healthChanged.connect(hp_bar._update_bar)
		hp_bar._update_bar()

func _connect_to_boss() -> void:
	await get_tree().process_frame
	var boss = get_tree().get_first_node_in_group("boss")
	if boss and boss.has_signal("boss_defeated"):
		boss.boss_defeated.connect(_on_boss_defeated)

func _on_boss_defeated() -> void:
	boss_defeated = true
	set_process(false)
	bgm.stop()
	await get_tree().create_timer(0.5).timeout
	_play_music(victory_music)

func _process(_delta: float) -> void:
	if get_tree().current_scene == null:
		return
	var scene_name = get_tree().current_scene.name
	var new_music = boss_music if scene_name == "02" else normal_music
	
	if new_music and new_music != current_music:
		_play_music(new_music)

func _play_music(music: AudioStream) -> void:
	if music and bgm:
		current_music = music
		bgm.stream = music
		bgm.play()
