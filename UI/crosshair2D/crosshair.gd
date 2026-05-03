extends Node2D


@export var animateToggle = true
@export var constrainArea = true
@export var maxConstraint = Vector2(10000, 150)
@export var minConstraint = Vector2(0, 0)

@onready var animator = $AnimationPlayer


func _ready():
	maxConstraint.x = get_viewport().size.x
	if animateToggle:
		animator.play("fluidity")

func _input(event):
	if event is InputEventMouseMotion:
		if constrainArea:
				global_position = event.global_position.clamp(minConstraint, maxConstraint)
		else:
			global_position = event.global_position
