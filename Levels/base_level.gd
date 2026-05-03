extends Node2D

@onready var levelCompleteUI = $LevelCompleteUI

signal level_complete

func _ready():
	levelCompleteUI.hide()
	for enemy in get_tree().get_nodes_in_group("Enemies"):
		print(enemy)
		enemy.enemyDied.connect(_on_enemy_died)
	EventBus.spawn_ball.emit()

func _on_enemy_died():
	var enemiesRemaining = get_tree().get_nodes_in_group("Enemies").size()
	
	if enemiesRemaining <= 1:
		level_complete.emit()
		levelCompleteUI.show()
