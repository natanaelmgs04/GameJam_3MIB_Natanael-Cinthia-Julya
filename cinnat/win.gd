extends Control

@onready var score_label: Label = $VBoxContainer/ScoreLabel

func _ready() -> void:
	score_label.text = "Pontuação: %d" % GameManager.score

func _on_menu_pressed() -> void:
	GameManager.reset()
	get_tree().change_scene_to_file("res://main_menu.tscn")

func _on_retry_pressed() -> void:
	GameManager.reset()
	get_tree().change_scene_to_file("res://level.tscn")
