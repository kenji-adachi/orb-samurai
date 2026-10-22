extends Node2D


@export var animateToggle = true
@export var constrainArea = true
@export var maxConstraint = Vector2(10000, 150)
@export var minConstraint = Vector2(0, 0)

@onready var animator = $AnimationPlayer

var is_mobile: bool = false


func _ready():
	maxConstraint.x = get_viewport().size.x
	if animateToggle:
		animator.play("fluidity")
		
	# Check platform once at startup
	is_mobile = OS.has_feature("mobile") or OS.has_feature("web_android") or OS.has_feature("web_ios")


func _input(event):
	# DESKTOP ONLY: Listen to global mouse movement safely
	if not is_mobile and event is InputEventMouseMotion:
		set_crosshair_position(event.global_position)


# MOBILE ONLY: A dedicated function for the touch zone to call
func update_from_mobile_touch(screen_position: Vector2) -> void:
	# Convert the canvas screen touch into world coordinates
	var world_pos = get_canvas_transform().affine_inverse() * screen_position
	set_crosshair_position(world_pos)


# The single source of truth for clamping the position
func set_crosshair_position(target_pos: Vector2) -> void:
	if constrainArea:
		global_position = target_pos.clamp(minConstraint, maxConstraint)
	else:
		global_position = target_pos
