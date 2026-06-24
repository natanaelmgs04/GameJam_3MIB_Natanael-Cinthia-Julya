extends CanvasLayer

@onready var score_label: Label = $ScoreLabel
@onready var lives_label: Label = $LivesLabel

func _ready() -> void:
	GameManager.score_changed.connect(_on_score_changed)
	GameManager.lives_changed.connect(_on_lives_changed)
	_on_score_changed(GameManager.score)
	_on_lives_changed(GameManager.lives)

func _on_score_changed(new_score: int) -> void:
	score_label.text = "Pontos: %d" % new_score

func _on_lives_changed(new_lives: int) -> void:
	lives_label.text = "Vidas: %d" % new_lives
