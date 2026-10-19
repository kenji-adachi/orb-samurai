extends Node

#Keeps track of game state for use anywhere needed

enum State {
	MAIN_MENU,
	PLAYING,
	PAUSED,
	GAME_OVER,
	WAITING,
	LEVEL_TRANSITION
}

var current_state: State = State.MAIN_MENU
var game_won = false
var challenge_won = false

signal state_changed(new_state: State)


func change_state(new_state: State):
	if current_state == new_state:
		return
	
	#var old_state = current_state
	current_state = new_state
	state_changed.emit(new_state)
