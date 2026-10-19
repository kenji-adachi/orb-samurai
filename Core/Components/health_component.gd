extends Node
class_name HealthComponent


signal healthChanged(currentHealth)
signal dead

@export var maxHealth: float = 100
var health: float

func _ready():
	health = maxHealth
	healthChanged.emit(health)
	
func take_damage(amount: float):
	health = clampf(health - amount, 0, maxHealth)
	healthChanged.emit(health)
	if health <= 0:
		dead.emit()
		
func heal(amount: float):
	health = clampf(health + amount, 0, maxHealth)
	healthChanged.emit(health)
	if health <= 0:
		dead.emit()
