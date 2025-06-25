extends AnimationPlayer

const wolf_script := preload("res://scenes/quests/story_quests/fox-tale/fox-tale_global_assets/enemys/wolf/wolf_enemy.gd")

@onready var wolf_enemy = self.owner as wolf_script

func _on_animation_finished(anim_name: StringName) -> void:
	if(anim_name == "atk_melee"):
		if (wolf_enemy.melee_area.is_player_in_area()):
			play("atk_melee")
		else:
			if wolf_enemy.target_follow:
				wolf_enemy.change_mode(wolf_enemy.Mode.FOLLOW)
			else:
				wolf_enemy.change_mode(wolf_enemy.Mode.PATROLL)
