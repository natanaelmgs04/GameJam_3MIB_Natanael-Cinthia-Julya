extends CharacterBody2D

const WALK_SPEED = 300.0
const RUN_SPEED = 500.0
const JUMP_VELOCITY = -600.0

var speed_boost := false
var speed_boost_timer := 0.0
var start_position: Vector2

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var inv_timer: Timer = $InvincibilityTimer

func _ready() -> void:
	start_position = global_position
	GameManager.game_over.connect(_on_game_over)
	inv_timer.timeout.connect(_on_inv_timeout)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction = Input.get_axis("left", "right")
	var is_running = Input.is_action_pressed("run")
	var speed = RUN_SPEED if is_running else WALK_SPEED

	if speed_boost:
		speed *= 2.0
		speed_boost_timer -= delta
		if speed_boost_timer <= 0.0:
			speed_boost = false

	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true

	if is_on_floor():
		if direction == 0:
			animated_sprite.play("idle")
		elif is_running:
			animated_sprite.play("run")
		else:
			animated_sprite.play("walk")
	else:
		animated_sprite.play("jump")

	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()

func take_damage() -> void:
	if inv_timer.time_left > 0:
		return
	inv_timer.start(2.0)
	modulate = Color(1, 0.3, 0.3, 0.5)
	GameManager.lose_life()
	if GameManager.lives > 0:
		global_position = start_position
		velocity = Vector2.ZERO

func die() -> void:
	take_damage()

func activate_speed_boost() -> void:
	speed_boost = true
	speed_boost_timer = 5.0
	modulate = Color(1.0, 1.0, 0.3)

func _on_inv_timeout() -> void:
	if not speed_boost:
		modulate = Color.WHITE
	else:
		modulate = Color(1.0, 1.0, 0.3)

func _on_game_over() -> void:
	set_physics_process(false)
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_file("res://game_over.tscn")
