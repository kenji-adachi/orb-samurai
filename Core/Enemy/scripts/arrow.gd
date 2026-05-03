extends CharacterBody2D

@export var speed : float = 100
@export var directionVector = Vector2(0, 1)

func _ready():
	velocity = speed * directionVector.normalized()

func _process(delta):
	var collider = move_and_collide(velocity * delta)
	if collider:
		var player = collider.get_collider()
		player.damage(10)
		queue_free()
	if position.y >= 185:
		queue_free()
