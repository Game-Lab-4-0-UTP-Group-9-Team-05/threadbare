extends Node2D

var is_fighting: bool = false

@onready var hit_box: Area2D = %HitBox
@onready var got_hit_animation: AnimationPlayer = %GotHitAnimation
@onready var air_stream: Area2D = %AirStream
@onready var player_sprite: AnimatedSprite2D = %PlayerSprite

@onready var player: CharacterBody2D = self.owner as CharacterBody2D


func _ready() -> void:
	hit_box.body_entered.connect(_on_body_entered)
	air_stream.body_entered.connect(_on_air_stream_body_entered)


func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed(&"ui_accept"):
		is_fighting = true
	elif Input.is_action_just_released(&"ui_accept"):
		is_fighting = false


func _on_body_entered(body: Node2D) -> void:
	body = body as Projectile
	if not body:
		return
	body.add_small_fx()
	body.queue_free()
	got_hit_animation.play(&"got_hit")
	CameraShake.shake()


func _on_air_stream_body_entered(body: CharacterBody2D) -> void:
	pass




func _notification(what: int) -> void:
	match what:
		NOTIFICATION_DISABLED:
			got_hit_animation.play(&"RESET")
			got_hit_animation.advance(0)


func _on_air_stream_area_entered(area: Area2D) -> void:
	print("cuerpo detectado")
	if area.is_in_group("enemy"):
		print("enemigo detectado")
		area.lost_health(500)
