extends CharacterBody2D
 
const WALK_SPEED = 300.0
const RUN_SPEED = 500.0
const JUMP_VELOCITY = -400.0
 
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
 
func _physics_process(delta):
	if not is_on_floor():
		velocity += get_gravity() * delta
 
	# Pulo
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
 
	# Movimento
	var direction = Input.get_axis("left", "right")
	var is_running = Input.is_action_pressed("run")
 
	var speed = RUN_SPEED if is_running else WALK_SPEED
 
	# Inverter sprite
	if direction > 0:
		animated_sprite_2d.flip_h = false
	elif direction < 0:
		animated_sprite_2d.flip_h = true
 
	# Animações
	if is_on_floor():
		if direction == 0:
			animated_sprite_2d.play("idle")
		elif is_running:
			animated_sprite_2d.play("run")
		else:
			animated_sprite_2d.play("walk")
	else:
		animated_sprite_2d.play("jump")
 
	# Movimento horizontal
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
 
	move_and_slide()
