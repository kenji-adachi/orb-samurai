extends Enemy

@onready var shield = $Item

@export var shieldHealth = 200
var shielded = true



func _on_area_2d_body_entered(body):
	if shielded:
		shieldHealth -= 100
		hitFlash()
		if shieldHealth <= 0:
			shielded = false
			dropItem()
			await itemAnimator.animation_finished
			shield.hide()
	else:
		super(body)
	
