extends Control


@onready var buttonPressSFX = $Button/ButtonPressSFX

func _on_button_pressed():
	EventBus.buttonPress.emit()
	EventBus.reset_game.emit()
