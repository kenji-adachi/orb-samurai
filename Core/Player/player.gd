extends CharacterBody2D

@export var playerSpeed = 250

@onready var playerSprite = $AnimatedSprite2D
@onready var health = $HealthComponent
@onready var slashSFX = $SlashSFX
@onready var hitSFX = $HitSFX
@onready var bodyAnimation = $BodyAnimation

var currentAction = "none"

signal slashing


func _ready():
	playerSprite.play("idle")


#func _input(event):
	#if event is InputEventKey:
		#if event.is_action_pressed("right"):
			#if currentAction == "left":
				#currentAction = "none"
			#else:
				#currentAction = "right"
		#elif event.is_action_pressed("left"):
			#if currentAction == "right":
				#currentAction = "none"
			#else:
				#currentAction = "left"
		#if event.is_action_released("left") and currentAction == "none":
			#currentAction = "right"
		#elif event.is_action_released("left") and currentAction == "left":
			#currentAction = "none"
		#if event.is_action_released("right") and currentAction == "none":
			#currentAction = "left"
		#elif event.is_action_released("right") and currentAction == "right":
			#currentAction = "none"
		#match currentAction:
			#"none":
				#stopMovement()
			#"left":
				#moveLeft()
			#"right":
				#moveRight()


func slash():
	playerSprite.play("slash")
	slashSFX.play()
	slashing.emit()
	await playerSprite.animation_finished
	await get_tree().create_timer(0.2).timeout
	playerSprite.play("idle")


func damage(amount: float):
	health.take_damage(amount)
	bodyAnimation.play("hit")
	hitSFX.play()


func _physics_process(delta):
	var direction = Input.get_axis("left", "right")
	
	if direction != 0:
		velocity.x = direction * playerSpeed
	else:
		velocity.x = 0
	move_and_slide()


func _on_area_2d_body_entered(body):
	slash()

#func moveLeft():
	#velocity.x = -playerSpeed
#
#func moveRight():
	#velocity.x = playerSpeed
#
#func stopMovement():
	#velocity.x = 0
	
func rotatePlayer(directionVector: Vector2):
	look_at(directionVector)
	rotation += deg_to_rad(90)


func _on_health_component_dead():
	EventBus.player_died.emit()


func _on_health_component_health_changed(currentHealth):
	EventBus.player_health_changed.emit(currentHealth)
