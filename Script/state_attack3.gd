class_name State_Attack3 extends State

var attacking : bool = false
var attack_timer : SceneTreeTimer = null
var is_dashing : bool = true  

# Stamina system
static var stamina : int = 3 
static var max_stamina : int = 3
static var stamina_timers : Array[SceneTreeTimer] = []  

@export var attack_sound : AudioStream
@export_range(1,20,0.5) var decelerate_speed : float = 5
@export var dash_speed : float = 400
@export var dash_duration : float = 0.05
@export var stamina_cooldown : float = 7.0  

@onready var run : State = $"../Run"
@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"
@onready var idle: State_Idle = $"../Idle"
@onready var audio : AudioStreamPlayer2D = $"../../Audio/Attack"
@onready var hurt_box: HurtBox = %AttackHurtBox
@onready var animated_sprite : AnimatedSprite2D = $"../../AnimatedSprite2D"

func Enter() -> void:
	if stamina <= 0:
		print("No stamina! Wait for cooldown. Stamina: ", stamina, "/", max_stamina)
		attacking = false
		return
	
	stamina -= 1
	print("Dash used! Stamina remaining: ", stamina, "/", max_stamina)
	
	var cooldown_timer = get_tree().create_timer(stamina_cooldown)
	stamina_timers.append(cooldown_timer)
	cooldown_timer.timeout.connect(_restore_stamina)
	
	player.updateAnimation("attack3")
	animation_player.animation_finished.connect(EndAttack)
	
	audio.stream = attack_sound
	audio.pitch_scale = randf_range(0.95, 1.05)
	audio.play()
	
	attacking = true
	is_dashing = true
	hurt_box.monitoring = false
	
	player.velocity = player.cardinal_direction * dash_speed
	
	var dash_timer = get_tree().create_timer(dash_duration)
	dash_timer.timeout.connect(_stop_dash)
	
	attack_timer = get_tree().create_timer(0.05)
	attack_timer.timeout.connect(_enable_hurt_box)

func _restore_stamina() -> void:
	if stamina < max_stamina:
		stamina += 1
		print("Stamina restored! Stamina: ", stamina, "/", max_stamina)

func _stop_dash() -> void:
	is_dashing = false

func _enable_hurt_box() -> void:
	if attacking:
		hurt_box.monitoring = true

func Exit() -> void:
	if animation_player.animation_finished.is_connected(EndAttack):
		animation_player.animation_finished.disconnect(EndAttack)
	attacking = false
	is_dashing = false
	hurt_box.monitoring = false 
	
	if attack_timer != null and attack_timer.timeout.is_connected(_enable_hurt_box):
		attack_timer.timeout.disconnect(_enable_hurt_box)
	attack_timer = null

func Process(_delta : float) -> State:
	if stamina <= 0 and not attacking:
		if player.direction == Vector2.ZERO:
			return idle
		else:
			return run
	
	if !is_dashing:
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
