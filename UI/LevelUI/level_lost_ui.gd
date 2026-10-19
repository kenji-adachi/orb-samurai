extends Control


func _on_retry_button_pressed():
	EventBus.buttonPress.emit()
	EventBus.retry_level.emit(ResourceUID.path_to_uid(self.get_parent().scene_file_path))


func _on_give_up_button_pressed():
	EventBus.buttonPress.emit()
	EventBus.reset_game.emit()
