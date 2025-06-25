extends AnimatedSprite2D

@onready var wolf: CharacterBody2D = owner


func _process(_delta: float) -> void:
	if not wolf:
		return
	if wolf.velocity.is_zero_approx():
		return
	if not is_zero_approx(wolf.velocity.x):
		flip_h = wolf.velocity.x > 0


func look_at_side(side: Enums.LookAtSide) -> void:
	if side == 0:
		return
	flip_h = side < 0
