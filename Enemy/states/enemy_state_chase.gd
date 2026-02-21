class_name EnemyStateChase
extends EnemyState

@export var anim_name : String = "run"
@export var chase_speed : float = 40.0
@export var turn_rate : float = 0.25

# Distance to switch to attack
@export var attack_distance : float = 20.0

# Separation (soft anti-stacking)
@export var separation_distance : float = 30.0
@export var separation_force : float = 50.0
@export var min_separation_strength : float = 0.15   
@export var disable_separation_near_player : float = 28.0  

# Animation update
@export var direction_change_threshold : float = 0.3

@export_category("AI")
@export var vision_area : VisionArea
@export var attack_state : EnemyState
@export var next_state : EnemyState

var _direction : Vector2 = Vector2.ZERO
var _last_animation_direction : Vector2 = Vector2.ZERO

## Called once
func init() -> void:
	if vision_area:
		vision_area.player_entered.connect(_on_player_enter)

	if not enemy.is_in_group("enemies"):
		enemy.add_to_group("enemies")

## Enter chase
func Enter() -> void:
	enemy.updateAnimation(anim_name)
	_last_animation_direction = Vector2.ZERO

## Chase logic
func Process(_delta : float) -> EnemyState:
	if PlayerManager.player == null:
		return next_state

	var player_pos := PlayerManager.player.global_position
	var distance_to_player := enemy.global_position.distance_to(player_pos)

	# Switch to attack when close and attack is off cooldown
	if distance_to_player <= attack_distance:
		if attack_state is EnemyStateAttack and attack_state.is_ready():
			return attack_state

	# Direction to player
	var new_dir := enemy.global_position.direction_to(player_pos)

	# 🧠 Apply soft separation
	var separation := _get_separation_force(distance_to_player)
	new_dir = (new_dir + separation).normalized()

	# Smooth turning
	_direction = lerp(_direction, new_dir, turn_rate)
	enemy.velocity = _direction * chase_speed

	# Animation update
	if _should_update_animation(_direction):
		if enemy.setDirection(_direction):
			enemy.updateAnimation(anim_name)
			_last_animation_direction = _direction

	return null

func Physics(_delta : float) -> EnemyState:
	return null

## Animation update check
func _should_update_animation(new_dir : Vector2) -> bool:
	if _last_animation_direction == Vector2.ZERO:
		return true
	return abs(_last_animation_direction.angle_to(new_dir)) > direction_change_threshold

## 🧠 SMART separation (NO jitter)
func _get_separation_force(distance_to_player : float) -> Vector2:
	# 🔴 Disable separation when almost close enough to attack
	if distance_to_player <= disable_separation_near_player:
		return Vector2.ZERO

	var separation := Vector2.ZERO
	var count := 0

	for other in get_tree().get_nodes_in_group("enemies"):
		if other == enemy or not is_instance_valid(other):
			continue

		var dist := enemy.global_position.distance_to(other.global_position)
		if dist > 0.0 and dist < separation_distance:
			var push := enemy.global_position.direction_to(other.global_position)
			var strength := 1.0 - (dist / separation_distance)
			separation -= push * strength
			count += 1

	if count == 0:
		return Vector2.ZERO

	# Normalize and scale softly
	separation = separation.normalized()
	var scaled_strength := separation_force / chase_speed

	# 🔒 Clamp so separation NEVER beats chase
	scaled_strength = clamp(
		scaled_strength,
		min_separation_strength,
		0.4
	)

	return separation * scaled_strength

## Vision trigger
func _on_player_enter() -> void:
	state_machine.change_state(self)
