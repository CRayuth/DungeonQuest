extends ProgressBar

var cooldown_progress : float = 0.0

func _ready():
	max_value = 100  
	value = 100

func _process(delta):
	var stamina_percent = (float(State_Attack3.stamina) / float(State_Attack3.max_stamina)) * 100
	
	if State_Attack3.stamina < State_Attack3.max_stamina and State_Attack3.stamina_timers.size() > 0:
		var oldest_timer = State_Attack3.stamina_timers[0]
		var time_left = oldest_timer.time_left
		var cooldown_percent = ((7.0 - time_left) / 7.0) * (100.0 / State_Attack3.max_stamina)
		
		value = stamina_percent + cooldown_percent
	else:
		value = stamina_percent
	
	if value < 33:
		modulate = Color.RED
	elif value < 66:
		modulate = Color.ORANGE
	else:
		modulate = Color.CYAN
