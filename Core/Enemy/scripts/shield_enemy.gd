extends Enemy

@onready var shield = $Item
@onready var shieldBreakSFX = $ShieldBreak
@onready var shieldHitSFX = $ShieldHit

@export var shieldHealth = 200
var shielded = true



func _on_area_2d_body_entered(body):
	if shielded:
		shieldHealth -= 100
		hitFlash()
		particles.emitting = true
		shieldHitSFX.play(0.12)
		if shieldHealth <= 0:
			shielded = false
			shieldBreakSFX.play()
			dropItem()
			await itemAnimator.animation_finished
			shield.hide()
	else:
		super(body)
	
