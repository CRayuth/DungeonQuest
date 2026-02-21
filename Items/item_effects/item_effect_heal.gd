class_name ItemEffectHeal extends ItemEffect

@export var heal_amount : int = 20
@export var audio : AudioStream

func use()-> void:
	PlayerManager.player.hp = PlayerManager.player.hp + heal_amount
	PauseMenu.play_audio(audio)
