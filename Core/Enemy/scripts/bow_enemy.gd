extends Enemy

@onready var arrowTimer = $Timer
@onready var arrowSpawn = $Marker2D
const arrowScene : PackedScene = preload("uid://chchw4pj4t7e5")



func _on_timer_timeout():
	shootArrow()


func shootArrow():
	var newArrow = arrowScene.instantiate()
	newArrow.global_position = arrowSpawn.global_position
	add_sibling(newArrow)
