class_name EnemyStateDestroy
extends EnemyState

const PICKUP = preload("res://Items/item_pickup/item_pickup.tscn")

@export var anim_name : String = "destroy"

@export_category("Item Drops")
@export var drops : Array[EnemyItemDrop]
var _damage_position : Vector2

signal boss_defeated

## Called once when state is created
func init() -> void:
	enemy.enemy_destroyed.connect(_on_enemy_destroy)

## When this state starts
func Enter() -> void:
	enemy.invulnerable = true
	enemy.velocity = Vector2.ZERO
	
	enemy.updateAnimation(anim_name)
	enemy.animation_player.animation_finished.connect(_on_animation_finished)
	
	call_deferred("drop_items")
	
	await enemy.animation_player.animation_finished
	boss_defeated.emit()
	enemy.queue_free()

## When this state ends
func Exit() -> void:
	pass

func Process(_delta : float) -> EnemyState:
	return null

func Physics(_delta : float) -> EnemyState:
	return null

## Triggered when enemy is killed
func _on_enemy_destroy( hurt_box : HurtBox) -> void:
	_damage_position = hurt_box.global_position
	state_machine.change_state(self)
	
func _on_animation_finished(_a : String) -> void:
	enemy.queue_free()

## Item drop logic
func drop_items() -> void:
	if drops.is_empty():
		return
	
	for drop_data in drops:
		if drop_data == null or drop_data.item == null:
			continue
		
		var drop_count := drop_data.get_drop_count()
		
		for i in range(drop_count):
			var drop := PICKUP.instantiate() as ItemPickup
			drop.item_data = drop_data.item
			
			var offset_radius := randf_range(0.0, 16.0)
			var offset_angle := randf_range(0.0, TAU)
			drop.global_position = enemy.global_position + Vector2.RIGHT.rotated(offset_angle) * offset_radius
			
			var speed := randf_range(20.0, 80.0)
			var angle := randf_range(0.0, TAU)
			drop.velocity = Vector2.RIGHT.rotated(angle) * speed
			
			enemy.get_parent().add_child.call_deferred(drop)
