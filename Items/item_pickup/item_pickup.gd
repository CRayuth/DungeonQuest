@tool
class_name ItemPickup extends CharacterBody2D

@export var item_data : ItemData : set = _set_item_data
@export var decelerate_speed : float = 200.0
@export var bounce_enabled : bool = true

@onready var area_2d: Area2D = $Area2D
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

func _ready() -> void:
	_update_texture()
	if Engine.is_editor_hint():
		return
	area_2d.body_entered.connect(_on_body_entered)
	
func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint():
		return
	
	# Decelerate the velocity
	velocity = velocity.move_toward(Vector2.ZERO, decelerate_speed * delta)
	
	# Move and handle collisions
	if bounce_enabled:
		var collision_info = move_and_collide(velocity * delta)
		if collision_info:
			velocity = velocity.bounce(collision_info.get_normal()) * 0.5 # Reduce bounce intensity
	else:
		move_and_slide()
	
func _on_body_entered(b) -> void: 
	if b is Player:
		if item_data:
			if PlayerManager.INVENTORY_DATA.add_item(item_data) == true: 
				item_picked_up()
	
func item_picked_up() -> void: 
	area_2d.body_entered.disconnect(_on_body_entered)
	audio_stream_player_2d.play()
	visible = false
	await audio_stream_player_2d.finished
	queue_free()

func _set_item_data(value : ItemData) -> void:
	item_data = value
	_update_texture()
	
func _update_texture() -> void:
	if item_data and sprite_2d:
		sprite_2d.texture = item_data.texture
