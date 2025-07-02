extends CharacterBody2D

signal mode_changed(mode: Mode)

enum Mode {
	IDLE,
	MOVE,
	ATACK
}

@export var speed := 40
@export var mode : Mode = Mode.IDLE

@onready var animation : AnimatedSprite2D = $slimegreen_enemy_sprite
@onready var player : CharacterBody2D = null

var attack_distance := 20.0
var cooldown := 1.5
var time := 0.0

func _ready() -> void:
	match mode:
		Mode.IDLE: init_idle()
		Mode.MOVE: init_move()
		Mode.ATACK: init_atack()

func _physics_process(delta: float) -> void:
	time += delta
	match mode:
		Mode.IDLE: process_idle()
		Mode.MOVE: process_move()
		Mode.ATACK: process_atack()
	move_and_slide()

# ===== STATES =====

func init_idle() -> void:
	animation.stop()
	velocity = Vector2.ZERO

func process_idle() -> void:
	if player and global_position.distance_to(player.global_position) < 100:
		change_mode(Mode.MOVE)

func init_move() -> void:
	animation.play("walk")

func process_move() -> void:
	if not player:
		return
	var dir = (player.global_position - global_position).normalized()
	velocity = dir * speed
	if global_position.distance_to(player.global_position) < attack_distance:
		change_mode(Mode.ATACK)

func init_atack() -> void:
	animation.play("atk")
	velocity = Vector2.ZERO
	time = 0.0

func process_atack() -> void:
	if time > cooldown:
		change_mode(Mode.MOVE)

# ===== TRANSITION =====

func change_mode(new_mode: Mode) -> void:
	if mode == new_mode:
		return
	mode = new_mode
	mode_changed.emit(mode)
	match new_mode:
		Mode.IDLE: init_idle()
		Mode.MOVE: init_move()
		Mode.ATACK: init_atack()
