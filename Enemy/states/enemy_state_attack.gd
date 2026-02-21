class_name EnemyStateAttack
extends EnemyState

@export var anim_name : String = "attack"
@export var attack_duration : float = 2
@export var attack_range : float = 5
@export var attack_cooldown : float = 1.0  

@export_category("AI")
@export var attack_area : HurtBox
@export var chase_state : EnemyState

var _timer : float = 0.0
var _attacked : bool = false
var _can_attack : bool = true  

## Called by chase state to check if attack is off cooldown
func is_ready() -> bool:
	return _can_attack

func Enter() -> void:
	enemy.velocity = Vector2.ZERO
	enemy.updateAnimation(anim_name)
	_timer = attack_duration
	_attacked = false
	_can_attack = false

	if attack_area:
		# Defer to avoid "flushing queries" physics error
		attack_area.set_deferred("monitoring", false)
		if not attack_area.is_connected("body_entered", Callable(self, "_on_attack_hit")):
			attack_area.body_entered.connect(Callable(self, "_on_attack_hit"))

func Exit() -> void:
	if attack_area:
		attack_area.set_deferred("monitoring", false)
	
	# Start cooldown timer when exiting
	get_tree().create_timer(attack_cooldown).timeout.connect(func(): _can_attack = true)

func Process(delta : float) -> EnemyState:
	if PlayerManager.player == null:
		return chase_state
	
	var player_pos = PlayerManager.player.global_position
	
	_timer -= delta
	if _timer <= 0.0:
		return chase_state
	
	enemy.setDirection(enemy.global_position.direction_to(player_pos))
	
	# Enable attack area at the midpoint of the attack animation (once per swing)
	if not _attacked and _timer <= attack_duration * 0.6:
		_attacked = true
		if attack_area:
			attack_area.set_deferred("monitoring", true)
	
	return null
