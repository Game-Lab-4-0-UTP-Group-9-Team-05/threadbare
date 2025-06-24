extends CanvasLayer

@onready var health_label : Label = $HealthLabel

func setHealLabelText (health : float) -> void :
	health_label.text = "Vida: "+ str(health)
