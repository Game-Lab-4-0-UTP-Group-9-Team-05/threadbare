extends AnimatedSprite2D

@onready var slime_body : CharacterBody2D = owner

func _process(_delta: float) -> void:
	if not slime_body:
		return

	# Detecta si se está moviendo
	if slime_body.velocity.is_zero_approx():
		if animation != "idle":
			play("idle")
	else:
		if animation != "walk":
			play("walk")

	# Orientación: voltea el sprite según dirección horizontal
	if not is_zero_approx(slime_body.velocity.x):
		flip_h = slime_body.velocity.x < 0
