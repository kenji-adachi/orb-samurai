extends Node2D

@export var aimLineOn = true

const ballScene : PackedScene = preload("uid://d0d00kkpa18ii")

@onready var player = $Player
@onready var ballSpawn = $Player/BallSpawn
@onready var crosshair = $Crosshair
@onready var aimLine = $AimLine
@onready var mobile_ui = $MobileControls

var ballForming = false
var ball = null


func _ready():
	EventBus.spawn_ball.connect(_on_spawn_ball)
	Accesability.playerLocation = player.global_position
	
	if mobile_ui and OS.has_feature("mobile") or OS.has_feature("web_android") or OS.has_feature("web_ios"):
		var touch_zone = mobile_ui.get_node_or_null("AimTouchZone")
		if touch_zone:
			touch_zone.aim_touch_triggered.connect(crosshair.update_from_mobile_touch)


func _process(delta):
	Accesability.playerLocation = player.global_position
	playerRotation()
	if aimLineOn:
		updateAimLine()
	if ballForming:
		ball.global_position = ballSpawn.global_position
		await ball.formed
		ballForming = false
	
	
func spawnBall():
	ballForming = true
	ball = ballScene.instantiate()
	ball.global_position = ballSpawn.global_position
	add_child(ball)

func playerRotation():
	player.rotatePlayer(crosshair.global_position)


func _on_spawn_ball():
	spawnBall()


func _on_player_slashing():
	var slashDirection = ball.global_position.direction_to(crosshair.global_position)
	ball.launchBall(slashDirection)

func updateAimLine():
	aimLine.clear_points()
	aimLine.add_point(player.global_position)
	aimLine.add_point(crosshair.global_position)

func _on_death_area_body_entered(body):
	if body:
		body.queue_free()
		player.damage(25)
		spawnBall()
