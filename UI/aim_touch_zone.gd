extends Control

# This signal will broadcast exactly where the player is touching/dragging
signal aim_touch_triggered(global_touch_position: Vector2)

var touch_id: int = -1

func _gui_input(event: InputEvent) -> void:
	# _gui_input only triggers if the touch falls perfectly inside this node's boundaries!
	if event is InputEventScreenTouch:
		if event.pressed and touch_id == -1:
			touch_id = event.index
			aim_touch_triggered.emit(event.position)
		elif not event.pressed and event.index == touch_id:
			touch_id = -1 # Finger lifted up

	if event is InputEventScreenDrag and event.index == touch_id:
		# Track the dragging finger across the upper zone
		aim_touch_triggered.emit(event.position)
