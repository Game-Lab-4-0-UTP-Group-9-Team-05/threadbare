extends Area2D

const wolf_script := preload("res://scenes/quests/story_quests/fox-tale/fox-tale_global_assets/enemys/wolf/wolf_enemy.gd")

@onready var wolf_enemy = self.owner as wolf_script

func _on_body_entered(body: Node2D) -> void:
	if wolf_enemy.mode != wolf_enemy.Mode.FOLLOW:
		return
	if body.is_in_group("player") and wolf_enemy.mode != wolf_enemy.Mode.MELEE_ATACK:
		wolf_enemy.change_mode(wolf_enemy.Mode.MELEE_ATACK)

func is_player_in_area() -> bool:
	for body in get_overlapping_bodies():
		if body.is_in_group("player"):
			return true
	return false
