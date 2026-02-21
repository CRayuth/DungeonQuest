extends ProgressBar

func _update_bar():
	var player = PlayerManager.player
	if not player:
		return
	value = player.hp * 100 / player.max_hp
