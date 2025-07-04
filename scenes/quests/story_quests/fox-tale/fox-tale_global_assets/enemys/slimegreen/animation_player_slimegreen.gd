extends AnimationPlayer

const SlimeScript := preload("res://scenes/quests/story_quests/fox-tale/fox-tale_global_assets/enemys/slimegreen/slimegreen_enemy.gd")  # Ajusta la ruta exacta

@onready var slime : SlimeScript = owner as SlimeScript

func _on_animation_finished(anim_name: StringName) -> void:
	if anim_name == "atk":
		if slime.melee_area.is_player_in_area():
			play("atk")  
		elif slime.player:
			slime.change_mode(slime.Mode.MOVE)
		else:
			slime.change_mode(slime.Mode.IDLE)
