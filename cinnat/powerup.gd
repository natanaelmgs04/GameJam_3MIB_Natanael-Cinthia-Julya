extends Area2D

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("activate_speed_boost"):
		body.activate_speed_boost()
		GameManager.add_score(50)
		queue_free()
