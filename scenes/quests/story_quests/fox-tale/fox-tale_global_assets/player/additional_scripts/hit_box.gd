extends Area2D

func _ready() -> void:
	add_to_group("player")

func lost_health(heal: float) -> void:
	owner.lost_health(heal)
