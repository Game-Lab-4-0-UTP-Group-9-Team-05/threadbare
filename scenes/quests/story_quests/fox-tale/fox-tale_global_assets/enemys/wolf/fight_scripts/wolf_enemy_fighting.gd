extends Node2D

const wolf_script := preload("res://scenes/quests/story_quests/fox-tale/fox-tale_global_assets/enemys/wolf/wolf_enemy.gd")

@onready var wolf_enemy = self.owner as wolf_script

func _process(delta: float) -> void:
	if not wolf_enemy:
		return
	if wolf_enemy.velocity.is_zero_approx():
		return
	if not is_zero_approx(wolf_enemy.velocity.x):
		var desired_sign = sign(-wolf_enemy.velocity.x)
		if sign(scale.x) != desired_sign:
			scale.x *= -1
