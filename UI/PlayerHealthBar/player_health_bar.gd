extends Control

@onready var playerHealthBar = $Panel/TextureProgressBar


func _ready():
	playerHealthBar.max_value = 100
	EventBus.player_health_changed.connect(_on_player_health_changed)


func _on_player_health_changed(newPlayerHealth: float):
	playerHealthBar.value = newPlayerHealth
