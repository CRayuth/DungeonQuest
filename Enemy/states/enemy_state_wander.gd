class_name EnemyStateWander extends EnemyState

@export var anim_name : String = "run"
@export var wander_speed : float = 20.0

@export_category("AI")

@export var state_animation_duration : float = 0.5
@export var state_cycle_min : int = 1
@export var state_cycle_max : int = 3
@export var next_state : EnemyState

var _timer : float = 0.0
var _direction : Vector2

## What happens when the enemy enters this State?
func init() -> void:
	pass # Replace with function body.

## What happens when the player enter this State?
func Enter() -> void:
	_timer = randf_range(state_cycle_min, state_cycle_max) * state_animation_duration
	var rand = randi_range( 0 , 3 )
	_direction = enemy.DIR_4[rand]
	enemy.velocity = _direction * wander_speed
	enemy.setDirection(_direction)
	enemy.updateAnimation(anim_name)
	pass

## What happen when the player exits this State?
func Exit() -> void:
	pass
	
## What happen during the _process update in this State?
func Process(_delta : float) -> EnemyState:
	_timer -= _delta
	if _timer <= 0:
		return next_state
	return null
	
## What happens during the _physic_process update in this State?
func Physics(_delta : float) -> EnemyState:
	return null
	
