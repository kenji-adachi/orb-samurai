extends Node2D


@onready var gameMusic = $MusicGame


func _ready():
	gameMusic.play()
	StateMachine.current_state = StateMachine.State.WAITING
