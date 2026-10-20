extends CharacterBody2D
class_name Enemy

signal enemyDied

@export var itemTypeTexture : Texture2D

@onready var itemTexture = $Item
@onready var health = $HealthComponent
@onready var bodyAnimator = $BodyAnimation
@onready var itemAnimator = $ItemAnimation
@onready var bodyHitSFX = $BodyHitSFX
@onready var particles = $GPUParticles2D


func _ready():
	itemTexture.texture = itemTypeTexture


func _on_area_2d_body_entered(body):
	bodyHitSFX.play(0.11)
	hitFlash()
	particles.emitting = true
	health.take_damage(100)


func _on_health_component_dead():
	enemyDied.emit()
	await bodyAnimator.animation_finished
	#await bodyHitSFX.finished
	queue_free()

func hitFlash():
	bodyAnimator.play("hitFlash")

func dropItem():
	itemAnimator.play("dropItem")
