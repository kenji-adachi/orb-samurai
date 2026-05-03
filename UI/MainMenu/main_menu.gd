extends Control


@onready var orbAnimator = $OrbAnimation
@onready var flagAnimator = $FlagAnimation


func _ready():
	orbAnimator.play("orb")
	flagAnimator.play("flags")


func _on_start_game_button_pressed():
	EventBus.start_game.emit()
	self.queue_free()


func _on_options_button_pressed():
	pass # Replace with function body.


func _on_quit_game_button_pressed():
	get_tree().quit()
