class_name ItemEffectSword extends ItemEffect

## When the player uses/buys this sword, they deal double damage permanently
## by setting PlayerStats.damage_multiplier = 2.0.
@export var damage_multiplier: float = 2.0

func use() -> void:
	PlayerStats.damage_multiplier = damage_multiplier
	print("Sword equipped! Damage multiplier set to x", damage_multiplier)
