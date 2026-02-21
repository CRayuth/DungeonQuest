class_name State extends Node

## Store References to the player that this State belong to
static var player: Player
static var state_machine: PlayerStateMachine

func _ready() -> void:
	pass # Replace with function body.
	
func init() -> void:
	pass

## What happens when the player enter this State?
func Enter() -> void:
	pass

## What happen when the player exits this State?
func Exit() -> void:
	pass
	
## What happen during the _process update in this State?
func Process(_delta : float) -> State:
	return null
	
## What happens during the _physic_process update in this State?
func Physics(_delta : float) -> State:
	return null
	
## What happens with input events in this State?
func HandleInput(_event : InputEvent) -> State:
	return null
