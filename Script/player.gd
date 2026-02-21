class_name Player extends CharacterBody2D

signal DirectionChanged( new_direcction: Vector2)
signal player_damaged( hurt_box : HurtBox )
signal healthChanged()

var cardinal_direction : Vector2 = Vector2.DOWN
const DIR_4 = [ Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT, Vector2.UP ]
var direction : Vector2 = Vector2.ZERO

var invulnerable : bool = false
@export var hp : int = 100
@export var max_hp : int = 100

@onready var animatedsprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var state_machine : PlayerStateMachine = $StateMachine
@onready var hit_box: HitBox = $HitBox
@onready var effect_animation_player: AnimationPlayer = $EffectAnimationPlayer


func _ready():
	add_to_group("player")
	var spawn = get_tree().get_first_node_in_group("spawn_point")
	if spawn:
		global_position = spawn.global_position
	PlayerManager.player = self
	state_machine.Initialize(self)
	hit_box.Damaged.connect(_take_damage)
	update_hp(0)

func _process(_delta):
	direction = Vector2(
		Input.get_axis("left", "right"),
		Input.get_axis("up", "down")
	).normalized()
	
func _physics_process(_delta):
	move_and_slide()
	
func setDirection() -> bool:
	
	if direction == Vector2.ZERO:
		return false
	
	var direction_id : int = int( round( (direction + cardinal_direction * 0.1).angle() / TAU * DIR_4.size() ))
	var new_dir = DIR_4[direction_id]
	
	if new_dir == cardinal_direction:
		return false
		
	cardinal_direction = new_dir
	DirectionChanged.emit( new_dir )
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
		
func _take_damage(hurt_box: HurtBox) -> void:
	if invulnerable:
		return

	update_hp(-hurt_box.damage)
	healthChanged.emit()
	
	if hp > 0:
		player_damaged.emit(hurt_box)
	else:
		player_damaged.emit(hurt_box)
		update_hp(0)

	
func update_hp( amount : int ) -> void:
	hp = clampi( hp + amount, 0, max_hp)
	
func make_invulnerable( _duration : float = 1.0 ) -> void:
	invulnerable = true
	hit_box.monitoring = false
	await get_tree().create_timer(_duration).timeout
	invulnerable = false
	hit_box.monitoring = true
