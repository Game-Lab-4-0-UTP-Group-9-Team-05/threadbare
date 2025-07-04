extends Area2D

const SlimeScript := preload("res://scenes/quests/story_quests/fox-tale/fox-tale_global_assets/enemys/slimegreen/slimegreen_enemy.gd")  # Ajusta esta ruta al script real del slime

@onready var slime_enemy : SlimeScript = owner as SlimeScript

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player") and slime_enemy.mode == slime_enemy.Mode.MOVE:
		slime_enemy.player = null
		slime_enemy.change_mode(slime_enemy.Mode.IDLE)


func _on_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
