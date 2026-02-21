class_name EnemyState extends Node

## Stored a reference to the enemy that this state belongs to
var enemy : Enemy
var state_machine : EnemyStateMachine

## What happens when the enemy enters this State?
func init() -> void:
	pass # Replace with function body.

## What happens when the player enter this State?
func Enter() -> void:
	pass

## What happen when the player exits this State?
func Exit() -> void:
	pass
	
## What happen during the _process update in this State?
func Process(_delta : float) -> EnemyState:
	return null
	
## What happens during the _physic_process update in this State?
func Physics(_delta : float) -> EnemyState:
	return null
	
