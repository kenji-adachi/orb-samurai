extends Control


@onready var orbAnimator = $OrbAnimation
@onready var flagAnimator = $FlagAnimation
@onready var menuTexture = $TextureRect
@onready var challengeButton = $ChallengeLevelButton

@export var fade_duration: float = 0.15

var tween : Tween

func _ready():
	orbAnimator.play("orb")
	flagAnimator.play("flags")
	challengeButton.hide()
	if StateMachine.game_won:
		challengeButton.show()
	if SaveManager.save_data.highest_level > 1:
		$StartGameButton.hide()
		$ContinueGameButton.show()


func _on_start_game_button_pressed():
	EventBus.buttonPress.emit()
	EventBus.start_game.emit()
	self.queue_free()

func _on_quit_game_button_pressed():
	EventBus.buttonPress.emit()
	get_tree().quit()


func _on_challenge_level_button_pressed():
	EventBus.buttonPress.emit()
	EventBus.challenge.emit()
	self.queue_free()

func fade_to_color(target_color: Color):
	# Kill any running animation to prevent conflicts
	if tween and tween.is_running():
		tween.kill()
		
	# Create a smooth transition
	tween = create_tween()
	tween.tween_property(menuTexture, "modulate", target_color, fade_duration)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_OUT) 

func _on_challenge_level_button_mouse_entered():
	fade_to_color(Color(1, 0.01, 0.23, 1))

func _on_challenge_level_button_mouse_exited():
	fade_to_color(Color(1, 1, 1, 1))


func _on_reset_save_button_pressed():
	SaveManager.reset_save_data()
