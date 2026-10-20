extends Node2D

@onready var levelCompleteUI = $LevelCompleteUI
@onready var levelLostUI = $LevelLostUI
@onready var tutorialLabels = $TutorialMessages
@onready var startClickLabel = $StartLabel
@onready var unstuckButton = $Unstuck
@onready var awaitStart = true

var tick = 0
var tickCheck = 25

func _ready():
	tick = 0
	levelCompleteUI.hide()
	for enemy in get_tree().get_nodes_in_group("Enemies"):
		enemy.enemyDied.connect(_on_enemy_died)
	EventBus.player_died.connect(_on_player_died)
	EventBus.endGame.connect(_on_end_game)

# back up check if level complete fails on last enemy death
func _physics_process(delta):
	if StateMachine.current_state == StateMachine.State.PLAYING:
		tick = tick + 1
		if tick * delta >= tickCheck * delta:
			tick = 0
			checkLevelComplete()
		

func _input(event):
	if event is InputEventMouseButton and StateMachine.current_state == StateMachine.State.WAITING:
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
			StateMachine.change_state(StateMachine.State.PLAYING)
			startClickLabel.hide()
			EventBus.spawn_ball.emit()

func _on_enemy_died():
	checkLevelComplete()

func _on_player_died():
	StateMachine.change_state(StateMachine.State.LEVEL_TRANSITION)
	EventBus.level_lost.emit()
	tutorialLabels.hide()
	levelLostUI.show()

func _on_end_game():
	levelCompleteUI.hide()
	unstuckButton.hide()

func checkLevelComplete():
	var enemiesRemaining = get_tree().get_nodes_in_group("Enemies").size()
	
	if enemiesRemaining <= 0:
		StateMachine.change_state(StateMachine.State.LEVEL_TRANSITION)
		EventBus.level_complete.emit(ResourceUID.path_to_uid(self.scene_file_path))
		tutorialLabels.hide()
		levelCompleteUI.show()


func _on_unstuck_pressed():
	_on_player_died()
