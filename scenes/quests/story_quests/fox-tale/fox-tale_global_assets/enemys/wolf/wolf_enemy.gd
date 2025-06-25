extends CharacterBody2D

signal mode_changed(mode: Mode)

enum Mode {
	PATROLL,
	FOLLOW,
	MELEE_ATACK,
	TURN_BACK
}

@export var health : float = 500
@export var mode : Mode = Mode.PATROLL
@export var walk_spd : float = 100
@export var follow_spd: float = 150

@onready var animation : AnimationPlayer = $AnimationPlayer
@onready var detect_area : Area2D = $WolfEnemyFighting/DetectArea
@onready var follow_area : Area2D = $WolfEnemyFighting/FollowArea
@onready var melee_area : Area2D = $WolfEnemyFighting/MeleeArea

@onready var target_follow : CharacterBody2D = null

##Para patroll
func on_init_patroll() -> void:
	animation.play("idle")
	detect_area.process_mode = Node.PROCESS_MODE_INHERIT
	velocity = Vector2.ZERO

func on_physics_process_patroll() -> void:
	pass

func on_end_patroll() -> void:
	detect_area.process_mode = Node.PROCESS_MODE_DISABLED

##Para follow

func on_init_follow() -> void:
	animation.play("follow")
	follow_area.process_mode = Node.PROCESS_MODE_INHERIT

func on_physics_process_follow() -> void:
	if(!target_follow):
		return
	var pos_player = target_follow.global_position
	var direction = (pos_player - global_position).normalized()
	velocity = direction * follow_spd

func on_end_follow() -> void:
	follow_area.process_mode = Node.PROCESS_MODE_DISABLED

##Para melee atk

func on_init_melee_atk() -> void:
	animation.play("atk_melee")

func on_physics_process_melee_atk() -> void:
	pass

func on_end_melee_atk() -> void:
	pass

##Para turn back

func on_init_turn_back() -> void:
	pass

func on_physics_process_turn_back() -> void:
	pass

func on_end_turn_back() -> void:
	pass

func _physics_process(delta: float) -> void:
	match mode:
		Mode.PATROLL:
			on_physics_process_patroll()
		Mode.FOLLOW:
			on_physics_process_follow()
		Mode.MELEE_ATACK:
			on_physics_process_melee_atk()
		Mode.TURN_BACK:
			on_physics_process_turn_back()
	move_and_slide()

func change_mode(new_mode : Mode) -> void:
	var previous_mode : Mode = mode
	mode = new_mode
	if not is_node_ready():
		return
	if mode != previous_mode:
		mode_changed.emit(mode)
		print()
		match previous_mode:
			Mode.PATROLL:
				on_end_patroll()
			Mode.FOLLOW:
				on_end_follow()
			Mode.MELEE_ATACK:
				on_end_melee_atk()
			Mode.TURN_BACK:
				on_end_turn_back()
		
		match mode:
			Mode.PATROLL:
				on_init_patroll()
			Mode.FOLLOW:
				on_init_follow()
			Mode.MELEE_ATACK:
				on_init_melee_atk()
			Mode.TURN_BACK:
				on_init_turn_back()
