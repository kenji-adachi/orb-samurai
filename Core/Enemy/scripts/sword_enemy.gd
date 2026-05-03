extends Enemy

@onready var sword = $Item

@export var swordHealth = 100
var swordEquipped = true

func _on_area_2d_body_entered(body):
	if swordEquipped:
		swordHealth -= 100
		hitFlash()
		body.raiseSpeed(100)
		if swordHealth <= 0:
			swordEquipped = false
			dropItem()
			await itemAnimator.animation_finished
			sword.hide()
			
	else:
		super(body)
	
