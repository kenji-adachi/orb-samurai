extends Control


func _on_next_level_button_pressed():
	EventBus.level_change.emit(ResourceUID.path_to_uid(self.get_parent().scene_file_path))
	
