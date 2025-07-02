extends Area2D

const SlimeScript := preload("res://scenes/quests/story_quests/fox-tale/fox-tale_global_assets/enemys/slimegreen/slimegreen_enemy.gd")  # Ajusta la ruta exacta a tu script del slime

@onready var slime_enemy : SlimeScript = owner as SlimeScript

func _on_body_entered(body: Node2D) -> void:
	if slime_enemy.mode != slime_enemy.Mode.IDLE:
		return
	if body.is_in_group("player"):
		slime_enemy.player = body
		slime_enemy.change_mode(slime_enemy.Mode.MOVE)
