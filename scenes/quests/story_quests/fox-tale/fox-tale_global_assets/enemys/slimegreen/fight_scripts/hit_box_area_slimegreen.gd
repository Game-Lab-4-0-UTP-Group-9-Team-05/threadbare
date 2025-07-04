extends Area2D

func _ready() -> void:
	add_to_group("enemy")

func lost_health(heal:float) -> void:
	owner.lost_health(heal)


func _on_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
