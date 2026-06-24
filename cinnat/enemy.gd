extends CharacterBody2D

const SPEED = 80.0

var direction = 1

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var floor_left: RayCast2D = $FloorLeft
@onready var floor_right: RayCast2D = $FloorRight

func _ready() -> void:
	print("Enemy spawned at: ", global_position)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if not floor_left.is_colliding():
		direction = 1
	if not floor_right.is_colliding():
		direction = -1

	velocity.x = direction * SPEED
	anim.flip_h = direction > 0
	anim.play("walk")
	move_and_slide()

func die() -> void:
	print("Enemy died!")
	GameManager.add_score(100)
	queue_free()

func _on_body_area_body_entered(body: Node2D) -> void:
	if not body.has_method("take_damage"):
		return
	if body.velocity.y > 50:
		body.velocity.y = -350.0
		die()
	else:
		body.take_damage()
