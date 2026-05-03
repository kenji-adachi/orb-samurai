extends CharacterBody2D


@export_range(0, 100000) var ballSpeed = 150
@export var constantSpeed = true
@export var ballAcceleration = 1
@export var initialVectorDirection = Vector2(0, 0)

@onready var hitSfx = $AudioStreamPlayer2D
@onready var animator = $AnimationPlayer
@onready var collisioner = $CollisionShape2D

signal formed


func _ready():
	collisioner.set_deferred("disabled", true)
	animator.play("spawn")
	await animator.animation_finished
	formed.emit()
	collisioner.set_deferred("disabled", false)
	var startVector = Vector2(initialVectorDirection.x, initialVectorDirection.y)
	startBall(startVector)
	
	
	
func startBall(directionVector: Vector2):
	velocity = directionVector.normalized() * ballSpeed
	
	
func _physics_process(delta):
	#print(velocity.length())
	var collider = move_and_collide(velocity * delta)
	if collider:
		#print(collider)
		velocity = velocity.bounce(collider.get_normal())
		velocity = velocity.normalized() * ballSpeed
			#hitSfx.play()
		#if collider.get_collider_id() != previousCollider:
			#previousCollider = collider.get_collider_id()
			

func launchBall(directionVector: Vector2):
	velocity = directionVector.normalized() * ballSpeed
	#print("launch")
	
	
func raiseSpeed(acceleration: float):
	ballSpeed += acceleration
	velocity = velocity.normalized() * ballSpeed
