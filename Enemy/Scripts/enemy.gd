class_name Enemy extends CharacterBody2D

signal direction_changed(new_direction: Vector2)
signal enemy_damaged(hurt_box : HurtBox)
signal enemy_destroyed(hurt_box : HurtBox)

const DIR_4 = [Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT, Vector2.UP]

@export var hp : int = 100
@export var max_hp : int = 100

var cardinal_direction : Vector2 = Vector2.DOWN
var direction : Vector2 = Vector2.ZERO
var player : Player
var invulnerable : bool = false

@onready var animatedsprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var hit_box : HitBox = $HitBox
@onready var hurt_box: HurtBox = $HurtBox
@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var state_machine : EnemyStateMachine = $EnemyStateMachine
@onready var enemy_hp_bar: ProgressBar = $EnemyHP
@onready var label: Label = $Label
@onready var attack_hurt_box: HurtBox = $AnimatedSprite2D/AttackHurtBox

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hurt_box.monitoring = false
	hurt_box.monitorable = false
	
	attack_hurt_box.monitorable = false
	attack_hurt_box.monitoring = false
	
	# Initialize HP bar
	enemy_hp_bar.max_value = max_hp
	enemy_hp_bar.value = hp
	
	state_machine.initialize(self)
	player = PlayerManager.player
	
	# Connect the HitBox Damaged signal to _take_damage
	if hit_box:
		hit_box.Damaged.connect(_take_damage)
	else:
		push_error("HitBox not found!")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	label.text = "State: %s" % state_machine.current_state
	
func _physics_process(_delta: float) -> void:
	move_and_slide()
	
func setDirection(_new_direction: Vector2) -> bool:
	direction = _new_direction
	if direction == Vector2.ZERO:
		return false
	
	var direction_id : int = int( round( (direction + cardinal_direction * 0.1).angle() / TAU * DIR_4.size() ))
	var new_dir = DIR_4[direction_id]
	
	if new_dir == cardinal_direction:
		return false
		
	cardinal_direction = new_dir
	direction_changed.emit( new_dir )
	return true
	
	
func updateAnimation(state : String) -> void:
	animation_player.play(state+"_"+animDirection())
	
func animDirection() -> String:
	match cardinal_direction:
		Vector2.DOWN:
			return "down"
		Vector2.UP:
			return "up"
		Vector2.LEFT:
			return "left"
		Vector2.RIGHT:
			return "right"
		_:
			return "down"
			
func _take_damage(_hurt_box : HurtBox) -> void:
	if invulnerable == true:
		return
	
	# Apply player damage multiplier (e.g. x2 when sword upgrade is active)
	hp -= int(_hurt_box.damage * PlayerStats.damage_multiplier)
	update_hp_bar()
	
	enemy_damaged.emit(_hurt_box)
	
	if hp <= 0:
		_die(_hurt_box)
		
func _die(hurt_box : HurtBox) -> void:
	invulnerable = true
	if hurt_box:
		$HurtBox.set_deferred("monitoring", false)
		$HurtBox.set_deferred("monitorable", false)
	enemy_destroyed.emit(hurt_box)
		
func update_hp_bar():
	enemy_hp_bar.value = hp
