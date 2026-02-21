class_name HeartGUI extends Control

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var value : int = 2 :
	set( _value ):
		value = _value
		update_sprite()



func update_sprite() -> void:
	animated_sprite_2d.frame = value
