extends Node

const SAVE_PATH := "user://save_game.json"

# Default save data
var save_data := {
	"game_completed": false,
	"highest_level": 1
}


func save_game() -> void:
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		var json_string := JSON.stringify(save_data)
		file.store_line(json_string)


func load_game() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		save_game() # Create default save if it doesn't exist
		return
	
	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file:
		var json_string := file.get_line()
		var json := JSON.new()
		var error := json.parse(json_string)
		if error == OK:
			var loaded_data: Dictionary = json.get_data()
			# Merge loaded data into structure
			save_data.game_completed = loaded_data.get("game_completed", false)
			save_data.highest_level = loaded_data.get("highest_level", 1)
		else:
			push_error("Error parsing save file JSON: ", json.get_error_message())

func reset_save_data() -> void:
	# Check if the file exists before trying to delete it
	if DirAccess.remove_absolute(SAVE_PATH) == OK:
		print("Save data successfully wiped!")
		save_data.game_completed = false
		save_data.highest_level = 1
		EventBus.save_reset.emit()
	else:
		print("No save file to delete or error occurred.")
	
