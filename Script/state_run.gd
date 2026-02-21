class_name State_Run extends State

@export var move_speed : float = 125

@onready var idle : State = $"../Idle"
@onready var attack1: State_Attack = $"../Attack"
@onready var attack2: State_Attack2 = $"../Attack2"
@onready var attack3: State_Attack3 = $"../Attack3"


## What happens when the player enter this State?
func Enter() -> void:
	pass

## What happen when the player exits this State?
func Exit() -> void:
	pass
	
## What happen during the _process update in this State?
func Process(_delta : float) -> State:
	if player.direction == Vector2.ZERO:
		return idle
		
	player.velocity = player.direction * move_speed
	
	if player.setDirection():
		player.updateAnimation("run")
	
	return null
	
## What happens during the _physic_process update in this State?
func Physics(_delta : float) -> State:
	return null
	
## What happens with input events in this State?
func HandleInput(_event : InputEvent) -> State:
	if _event.is_action_pressed("light_attack"):
		return attack1
	elif _event.is_action_pressed("heavy_attack"):
		return attack2
	elif _event.is_action_pressed("dash"):
		return attack3
	return null
