extends CharacterBody2D

signal mode_changed(mode: Mode)

## Controls how the player can interact with the world around them.
enum Mode {
	## Player can explore the world, interact with items and NPCs, but is not
	## engaged in combat. Combat actions are not available in this mode.
	COZY,
	## Player is engaged in combat. Player can use combat actions.
	FIGHTING,
	## Player can't be controlled anymore.
	DEFEATED,
	## Player can't be controlled because is in cinematic
	CINEMATIC
}

const DEFAULT_SPRITE_FRAME: SpriteFrames = preload("uid://vwf8e1v8brdp")

## The character's name. This is used to highlight when the player's character
## is speaking during dialogue.
@export var player_name: String = "Foxy"

## Para la vida del personaje
@export var health : float = 100

## Para activar movimiento
@export var movimiento_activo : bool = true

## Controls how the player can interact with the world around them.
@export var mode: Mode = Mode.COZY:
	set = _set_mode
@export_range(10, 100000, 10) var walk_speed: float = 300.0
@export_range(10, 100000, 10) var run_speed: float = 500.0
@export_range(10, 100000, 10) var stopping_step: float = 1500.0
@export_range(10, 100000, 10) var moving_step: float = 4000.0

## The SpriteFrames must have specific animations with a certain amount of frames.
## See [member REQUIRED_ANIMATION_FRAMES].
@export var sprite_frames: SpriteFrames = DEFAULT_SPRITE_FRAME:
	set = _set_sprite_frames

@export_group("Sounds")
## Sound that plays for each step during the walk animation
@export var walk_sound_stream: AudioStream = preload("uid://cx6jv2cflrmqu"):
	set = _set_walk_sound_stream

var input_vector: Vector2

@onready var player_interaction: Node2D = %PlayerInteraction
@onready var player_fighting: Node2D = %PlayerFighting
@onready var player_sprite: AnimatedSprite2D = %PlayerSprite
@onready var _walk_sound: AudioStreamPlayer2D = %WalkSound
@onready var ui_player : CanvasLayer = %UIPlayer
@onready var got_hit : AnimationPlayer = %GotHitAnimation


func _set_mode(new_mode: Mode) -> void:
	var previous_mode: Mode = mode
	mode = new_mode
	if not is_node_ready():
		return
	match mode:
		Mode.COZY:
			_toggle_player_behavior(player_interaction, true)
			_toggle_player_behavior(player_fighting, false)
		Mode.FIGHTING:
			_toggle_player_behavior(player_interaction, false)
			_toggle_player_behavior(player_fighting, true)
		Mode.DEFEATED:
			_toggle_player_behavior(player_interaction, false)
			_toggle_player_behavior(player_fighting, false)
		Mode.CINEMATIC:
			_toggle_player_behavior(player_interaction, false)
			_toggle_player_behavior(player_fighting, false)
	if mode != previous_mode:
		mode_changed.emit(mode)


func _set_sprite_frames(new_sprite_frames: SpriteFrames) -> void:
	sprite_frames = new_sprite_frames
	if not is_node_ready():
		return
	if new_sprite_frames == null:
		new_sprite_frames = DEFAULT_SPRITE_FRAME
	player_sprite.sprite_frames = new_sprite_frames
	update_configuration_warnings()


func _toggle_player_behavior(behavior_node: Node2D, is_active: bool) -> void:
	behavior_node.visible = is_active
	behavior_node.process_mode = (
		ProcessMode.PROCESS_MODE_INHERIT if is_active else ProcessMode.PROCESS_MODE_DISABLED
	)


func _ready() -> void:
	_set_mode(mode)
	_set_sprite_frames(sprite_frames)
	ui_player.setHealLabelText(health)


func _unhandled_input(_event: InputEvent) -> void:
	var axis: Vector2 = Input.get_vector(&"ui_left", &"ui_right", &"ui_up", &"ui_down")

	var speed: float
	if Input.is_action_pressed(&"running"):
		speed = run_speed
	else:
		speed = walk_speed

	input_vector = axis * speed


## Returns [code]true[/code] if the player is running. When using an analogue joystick, this can be
## [code]false[/code] even if the player is holding the "run" button, because the joystick may be
## inclined only slightly.
func is_running() -> bool:
	# While walking diagonally with an analogue joystick, the input vector can be fractionally
	# greater than walk_speed, due to trigonometric/floating-point inaccuracy.
	return input_vector.length_squared() > (walk_speed * walk_speed) + 1.0


func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		return

	if player_interaction.is_interacting or mode == Mode.DEFEATED or mode == Mode.CINEMATIC or not movimiento_activo:
		velocity = Vector2.ZERO
		return

	var step: float
	if input_vector.is_zero_approx():
		step = stopping_step
	else:
		step = moving_step

	velocity = velocity.move_toward(input_vector, step * delta)
	
	move_and_slide()


func teleport_to(
	tele_position: Vector2,
	smooth_camera: bool = false,
	look_side: Enums.LookAtSide = Enums.LookAtSide.UNSPECIFIED
) -> void:
	var camera: Camera2D = get_viewport().get_camera_2d()

	if is_instance_valid(camera):
		var smoothing_was_enabled: bool = camera.position_smoothing_enabled
		camera.position_smoothing_enabled = smooth_camera
		global_position = tele_position
		%PlayerSprite.look_at_side(look_side)
		await get_tree().process_frame
		camera.position_smoothing_enabled = smoothing_was_enabled
	else:
		global_position = tele_position


func _set_walk_sound_stream(new_value: AudioStream) -> void:
	walk_sound_stream = new_value
	if not is_node_ready():
		await ready
	_walk_sound.stream = walk_sound_stream

func lost_health(h_lost : float) -> void:
	if got_hit.current_animation == "got_hit":
		return
	health -= h_lost
	if health <= 0:
		_set_mode(Mode.DEFEATED)
		return
	player_fighting.get_damage()
	ui_player.setHealLabelText(health)
	
