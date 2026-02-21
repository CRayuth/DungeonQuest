extends Node

## Global player stats singleton (autoload as "PlayerStats").
## Stores runtime modifiers applied by items/upgrades.

## Multiplier applied to all outgoing player damage.
## Default 1.0 = normal damage. Set to 2.0 when sword upgrade is active.
var damage_multiplier: float = 1.0

func reset() -> void:
	damage_multiplier = 1.0
