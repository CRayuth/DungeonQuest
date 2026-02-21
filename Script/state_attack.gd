class_name State_Attack extends State

var attacking : bool = false
var attack_timer : SceneTreeTimer = null
var slash_count : int = 0
var slash_timer : SceneTreeTimer = null

@export var attack_sound : AudioStream
@export_range(1,20,0.5) var decelerate_speed : float = 5
@export var slash_delay : float = 0.15  # Time between each slash sound

@onready var run : State = $"../Run"
@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"
@onready var idle: State_Idle = $"../Idle"
@onready var audio : AudioStreamPlayer2D = $"../../Audio/Attack"
@onready var hurt_box: HurtBox = %AttackHurtBox

func Enter() -> void:
	# Play single attack animation
	player.updateAnimation("attack1")
	animation_player.animation_finished.connect(EndAttack)
	
	# Start triple slash sound sequence
	slash_count = 0
	_play_slash_sound()
	
	attacking = true
	hurt_box.monitoring = false
	
	# Enable hurt box after delay
	attack_timer = get_tree().create_timer(0.35)
	attack_timer.timeout.connect(_enable_hurt_box)

func _play_slash_sound() -> void:
	# Play current slash
	audio.stream = attack_sound
	match slash_count:
		0:
			audio.pitch_scale = randf_range(0.9, 1.0)
		1:
			audio.pitch_scale = randf_range(1.0, 1.1)
		2:
			audio.pitch_scale = randf_range(1.1, 1.2)
	audio.play()
	
	slash_count += 1
	
	# Schedule next slash if not done
	if slash_count < 3:
		slash_timer = get_tree().create_timer(slash_delay)
		slash_timer.timeout.connect(_play_slash_sound)

func _enable_hurt_box() -> void:
	if attacking:
		hurt_box.monitoring = true

func Exit() -> void:
	animation_player.animation_finished.disconnect(EndAttack)
	attacking = false
	hurt_box.monitoring = false 
	
	if attack_timer != null and attack_timer.timeout.is_connected(_enable_hurt_box):
		attack_timer.timeout.disconnect(_enable_hurt_box)
	attack_timer = null
	
	# Clean up slash timer
	if slash_timer != null and slash_timer.timeout.is_connected(_play_slash_sound):
		slash_timer.timeout.disconnect(_play_slash_sound)
	slash_timer = null

func Process(_delta : float) -> State:
	player.velocity -= player.velocity * decelerate_speed * _delta
	
	if attacking == false:
		if player.direction == Vector2.ZERO:
			return idle
		else:
			return run
	return null

func Physics(_delta : float) -> State:
	return null

func HandleInput(_event : InputEvent) -> State:
	return null

func EndAttack(_newAnimName: String) -> void:
	attacking = false
