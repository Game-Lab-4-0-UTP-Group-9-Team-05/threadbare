extends CharacterBody2D

const WALK_SPEED = 40
const PATROL_RADIUS = 100
const MELEE_RANGE = 80
const DETECTION_RANGE = 200

@onready var sprite = $AnimatedSprite2D
@export var player: CharacterBody2D
@export var origin_position := Vector2.ZERO

@export var max_health := 100
var current_health := max_health
var is_dead := false

var direction = 1
var can_attack = true
var attack_cooldown = 1.5
var attack_timer = 0.0
var damage_applied := false
var is_attacking := false
var last_seen_position: Vector2
var going_to_last_position := false

func _ready():
	origin_position = global_position
	sprite.play("walk")
	sprite.connect("frame_changed", Callable(self, "_on_frame_changed"))

func _physics_process(delta):
	if is_dead:
		return

	if player is Player and player.mode == Player.Mode.DEFEATED:
		velocity = Vector2.ZERO
		sprite.play("idle")
		return

	var distance_to_player = global_position.distance_to(player.global_position)

	if distance_to_player < MELEE_RANGE and can_attack:
		velocity = Vector2.ZERO
		sprite.play("atk_melee")
		damage_applied = false
		can_attack = false
		is_attacking = true
		going_to_last_position = false
		last_seen_position = player.global_position
	elif distance_to_player < DETECTION_RANGE and not is_attacking:
		var direction_to_player = (player.global_position - global_position).normalized()
		velocity = direction_to_player * WALK_SPEED
		sprite.play("walk")
		sprite.flip_h = player.global_position.x > global_position.x
		last_seen_position = player.global_position
		going_to_last_position = true
	elif going_to_last_position and not is_attacking:
		var direction_to_target = last_seen_position - global_position
		if direction_to_target.length() > 5:
			velocity = direction_to_target.normalized() * WALK_SPEED
			sprite.play("walk")
		else:
			velocity = Vector2.ZERO
			sprite.play("idle")
	else:
		if not is_attacking:
			patrol()
			going_to_last_position = false

	if not can_attack:
		attack_timer += delta
		if attack_timer >= attack_cooldown:
			can_attack = true
			attack_timer = 0.0
			is_attacking = false

	move_and_slide()

	if velocity.length_squared() == 0 and sprite.animation != "atk_melee":
		sprite.play("idle")

func _on_frame_changed():
	if sprite.animation == "atk_melee" and sprite.frame == 4 and not damage_applied:
		if player and player.has_method("take_damage"):
			if global_position.distance_to(player.global_position) < MELEE_RANGE:
				player.take_damage(25)
				damage_applied = true

func patrol():
	if abs(global_position.x - origin_position.x) > PATROL_RADIUS:
		direction *= -1
	velocity.x = direction * WALK_SPEED
	velocity.y = 0
	sprite.play("walk")

func take_damage(amount: int):
	if is_dead:
		return

	current_health -= amount
	if current_health <= 0:
		die()

func die():
	is_dead = true
	velocity = Vector2.ZERO
	sprite.play("idle")
	set_physics_process(false)
