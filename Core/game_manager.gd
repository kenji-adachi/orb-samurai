# HI KJ! YOU'RE UNPRODUCTIVE TODAY BUT YOU'RE ALSO COOL. BUT YOU COULD BE COOLER IF YOU FINISHED THIS GAME, POSTED TO THE WEBSITE, RECORDED A VIDEO, AND POSTED THE VIDEO. <3 YOUR LOVING AND CARING AND BEAUTIFUL AND AMAZING AND SMART GIRLFRIEND

class_name GameManager
extends Node

@onready var world_manager = $World2D
@onready var ui_manager = $UIManager
@onready var level_manager = $World2D/LevelManager
@onready var playerCoreScene = preload("uid://c6uo7r5ra3ok2")

var current_ui_scene : Control = null
var current_level_scene : Node2D = null
var current_level_index : int = 1
var playerCore : Node2D = null

const level_reference : Dictionary = {
	1 : "uid://c0uvasppuqvsi",
	2 : "uid://bk6cpo70vv6ke"
}
const ui_reference : Dictionary = {
	"mainMenu": "uid://clxr6cidxhp8r"
}

func _ready():
	initialize_game()
	initialize_connections()


func initialize_game():
	load_ui_scene(ui_reference["mainMenu"])


func initialize_connections():
	EventBus.level_change.connect(_on_level_changed)
	EventBus.start_game.connect(_on_start_game)


func load_player_core():
	var newPlayerCore = playerCoreScene.instantiate()
	playerCore = newPlayerCore
	world_manager.add_child(newPlayerCore)


func unload_player_core():
	playerCore.queue_free()

func load_level_scene(new_scene : String = "", delete: bool = true, keep_running: bool = false):
	if current_level_scene != null:
		if delete:
			current_level_scene.queue_free()
		elif keep_running:
			current_level_scene.visible = false
		else:
			level_manager.remove_child(current_level_scene) # keeps in memory, does not run
	if new_scene != "":
		var new = load(new_scene).instantiate()
		level_manager.add_child(new)
		current_level_scene = new


func load_ui_scene(new_scene : String = "", delete: bool = true, keep_running: bool = false):
	if current_ui_scene != null:
		if delete:
			current_ui_scene.queue_free()
		elif keep_running:
			current_ui_scene.visible = false
		else:
			ui_manager.remove_child(current_ui_scene) # keeps in memory, does not run
	if new_scene != "":
		var new = load(new_scene).instantiate()
		ui_manager.add_child(new)
		current_ui_scene = new


func reset_game():
	pass
 

#signal event bus functions
func _on_start_game():
	load_player_core()
	load_level_scene("uid://c0uvasppuqvsi")


func _on_level_changed(currentLevel: String):
	var level_index = level_reference.find_key(currentLevel)
	if level_index >= level_reference.size(): #check for last level completed
		print("Game End")
	else: # go to next level
		load_level_scene(level_reference[level_index + 1])
