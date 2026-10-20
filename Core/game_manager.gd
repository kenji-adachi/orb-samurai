# This node is the CPU of the game, it controls level changes, game start, and game over.

class_name GameManager
extends Node

@onready var world_manager = $World2D
@onready var ui_manager = $UIManager
@onready var level_manager = $World2D/LevelManager
@onready var colorFilter = $CanvasModulate
@onready var playerCoreScene = preload("uid://c6uo7r5ra3ok2")
@onready var endGameScreen = preload("uid://kj5usds7ae6p")



#AUDIO
@onready var menuMusic = $MusicMenu
@onready var gameMusic = $MusicGame
@onready var buttonSFX = $ButtonPressSFX

var current_ui_scene : Control = null
var current_level_scene : Node2D = null
var current_level_index : int = 1
var playerCore : Node2D = null
var playingChallenge = false
var highest_level := 1
var game_complete := false
const DAY_COLOR   = Color(0.84, 0.904, 0.969) # Day Time
const NIGHT_COLOR = Color(0.082, 0.188, 0.286) #Night Time

# list of levels
const level_reference : Dictionary = {
	1 : "uid://c0uvasppuqvsi", # Tutorial Level 1 A
	2 : "uid://daqp31mxxtqag", # Tutorial Level 1 B
	3 : "uid://ca0cunxr66hyt", # Level 1
	4 : "uid://bk6cpo70vv6ke", # Tutorial Level 2 (Shield)
	5 : "uid://2bcmdlxicdin",  # Level 2
	6 : "uid://b074fyc0ki6xp", # Tutorial Level 3 (Archer)
	7 : "uid://b7vsmk02iimj",  # Level 3
	8 : "uid://ywka3luhlwdd",  # Tutorial Level 4 (Sword)
	9 : "uid://bohgd7wpd3sb2", # Level 4
	10: "uid://ct6ngql15n4si", # Rain Arrows
	11: "uid://cem2yhi16w7qq", # Flanking
	12: "uid://dkmbjej0rxgkb", # Formation
	13: "uid://dfjsigpmt7uji", # Elite Archer
}

const challengeLevel = "uid://dqwkpj54l5xn6" # Impoossible Hidden Challenge Level

# list of UI scenes
const ui_reference : Dictionary = {
	"mainMenu": "uid://clxr6cidxhp8r",
	"endGame" : "uid://kj5usds7ae6p",
	"challengeEnd" : "uid://bbc4pbrg6bpqi"
}

func _ready():
	initialize_game()
	initialize_connections()
	colorFilter.color = NIGHT_COLOR


func initialize_game():
	SaveManager.load_game()
	game_complete = SaveManager.save_data.game_completed
	highest_level = SaveManager.save_data.highest_level
	current_level_index = highest_level
	StateMachine.game_won = game_complete
	load_ui_scene(ui_reference["mainMenu"])
	gameMusic.stop()
	menuMusic.play()


func initialize_connections():
	EventBus.level_change.connect(_on_level_changed)
	EventBus.start_game.connect(_on_start_game)
	EventBus.level_complete.connect(_on_level_complete)
	EventBus.level_lost.connect(_on_level_lost)
	EventBus.retry_level.connect(_on_level_retry)
	EventBus.reset_game.connect(_on_reset_game)
	EventBus.buttonPress.connect(_on_button_press)
	EventBus.challenge.connect(_on_challenge_start)
	EventBus.save_reset.connect(_on_save_reset)
	StateMachine.state_changed.connect(_on_state_changed)
	

#player core runs everything related to the player and the ball
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

func update_time_of_day(currentLevelIndex: int):
	var colorScale: float = (currentLevelIndex - 1) / 13.0
	colorFilter.color = DAY_COLOR.lerp(NIGHT_COLOR, colorScale)

func level_transition():
	if StateMachine.current_state != StateMachine.State.LEVEL_TRANSITION:
		return
	unload_player_core()
 

#signal event bus functions
func _on_start_game():
	load_player_core()
	update_time_of_day(highest_level)
	load_level_scene(level_reference[highest_level])
	StateMachine.change_state(StateMachine.State.WAITING)
	menuMusic.stop()
	gameMusic.play()

func _on_level_complete(currentLevel: String):
	level_transition()
	var level_index = level_reference.find_key(currentLevel)
	if level_index >= level_reference.size(): # Game Complete, no level past highest level
		SaveManager.save_data.highest_level = level_index
	else: # Set highest level to the level after completed level
		SaveManager.save_data.highest_level = level_index + 1
	SaveManager.save_game()

func _on_level_lost():
	level_transition()

func _on_level_retry(currentLevel: String):
	var level_index = level_reference.find_key(currentLevel)
	load_player_core()
	load_level_scene(level_reference[level_index])
	StateMachine.change_state(StateMachine.State.WAITING)

func _on_level_changed(currentLevel: String):
	if playingChallenge:
		StateMachine.change_state(StateMachine.State.GAME_OVER)
		EventBus.endGame.emit()
		StateMachine.challenge_won = true
		load_ui_scene(ui_reference["challengeEnd"])
		return
	var level_index = level_reference.find_key(currentLevel)
	if level_index >= level_reference.size(): #check for last level completed
		StateMachine.change_state(StateMachine.State.GAME_OVER)
		EventBus.endGame.emit()
		StateMachine.game_won = true
		load_ui_scene(ui_reference["endGame"])
		SaveManager.save_data.game_completed = true
		SaveManager.save_game()
		
	else: # go to next level
		current_level_index = level_index + 1
		load_player_core()
		update_time_of_day(level_index + 1)
		load_level_scene(level_reference[level_index + 1])
		StateMachine.change_state(StateMachine.State.WAITING)

func _on_reset_game():
	initialize_game()

func _on_button_press():
	buttonSFX.play()

func _on_state_changed(newState: StateMachine.State):
	print("State: " + StateMachine.State.keys()[newState])

func _on_challenge_start():
	load_player_core()
	load_level_scene(challengeLevel)
	update_time_of_day(level_reference.size())
	StateMachine.change_state(StateMachine.State.WAITING)
	menuMusic.stop()
	gameMusic.play()
	playingChallenge = true

func _on_save_reset():
	current_ui_scene.queue_free()
	game_complete = SaveManager.save_data.game_completed
	highest_level = SaveManager.save_data.highest_level
	StateMachine.game_won = game_complete
	load_ui_scene(ui_reference["mainMenu"])
