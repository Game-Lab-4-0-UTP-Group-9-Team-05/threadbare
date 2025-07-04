extends Area2D

const wolf_script := preload("res://scenes/quests/story_quests/fox-tale/fox-tale_global_assets/enemys/wolf/wolf_enemy.gd")

@onready var wolf_enemy = self.owner as wolf_script

func _on_body_exited(body: Node2D) -> void:
	if not body is Area2D:
		return
	if(body.is_in_group("player") and wolf_enemy.mode == wolf_enemy.Mode.FOLLOW):
		wolf_enemy.target_follow = null
		wolf_enemy.change_mode(wolf_enemy.Mode.PATROLL)
