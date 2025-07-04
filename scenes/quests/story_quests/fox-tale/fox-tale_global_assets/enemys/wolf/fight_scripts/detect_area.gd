extends Area2D

const wolf_script := preload("res://scenes/quests/story_quests/fox-tale/fox-tale_global_assets/enemys/wolf/wolf_enemy.gd")

@onready var wolf_enemy = self.owner as wolf_script

func _on_body_entered(body: Node2D) -> void:
	if wolf_enemy.mode != wolf_enemy.Mode.PATROLL:
		return
	if(body.is_in_group("player")):
		wolf_enemy.change_mode(wolf_enemy.Mode.FOLLOW)
		wolf_enemy.target_follow = body
