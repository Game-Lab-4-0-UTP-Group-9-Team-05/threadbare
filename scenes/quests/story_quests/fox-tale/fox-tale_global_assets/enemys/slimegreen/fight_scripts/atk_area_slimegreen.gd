extends Area2D

const SlimeScript := preload("res://scenes/quests/story_quests/fox-tale/fox-tale_global_assets/enemys/slimegreen/slimegreen_enemy.gd")  # Ajusta la ruta al script del slime

@onready var slime_enemy : SlimeScript = owner as SlimeScript

func _on_body_entered(body: Node2D) -> void:
	if slime_enemy.mode != slime_enemy.Mode.MOVE:
		return
	if body.is_in_group("player") and slime_enemy.mode != slime_enemy.Mode.ATACK:
		slime_enemy.change_mode(slime_enemy.Mode.ATACK)

func is_player_in_area() -> bool:
	for body in get_overlapping_bodies():
		if body.is_in_group("player"):
			return true
	return false
