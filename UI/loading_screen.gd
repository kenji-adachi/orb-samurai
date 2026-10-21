extends Node2D


@onready var loadingProgress = $Cover/TextureProgressBar
@onready var booter = $Boot

const EFFECTS := [
	preload("uid://cwamujttsxgvh"),
	preload("uid://d0d00kkpa18ii"),
	preload("uid://vwdxliu34di4")
]

const SOUNDS := [
	preload("uid://fm8dniitkpr5"),
	preload("uid://cpj44ay4hss7r"),
	preload("uid://chtfe0sjiwocj"),
	preload("uid://0rn1i34grrr6"),
	preload("uid://dbq5afhy3blo0"),
	preload("uid://5qyfs848og5i"),
	preload("uid://cihn7ywe0omvn"),
	preload("uid://c5k3qmisrudh8"),
	preload("uid://y8vkk77joylj"),
	preload("uid://dlhop25207d3v")
]

func _ready():
	loadingProgress.value = 0
	load_assets()

func load_assets():
	
	for scene in EFFECTS:
		var node = scene.instantiate()
		booter.add_child(node)
		node.global_position = Vector2(160, 90)  # center of your view
		for p in node.find_children("*", "GPUParticles2D", true, false):
			p.restart()
		loadingProgress.value += 5
	
	for s in SOUNDS:
		var player := AudioStreamPlayer.new()
		player.stream = s
		player.volume_db = -80.0  # effectively silent
		booter.add_child(player)
		player.play()
		loadingProgress.value += 5
	
	for i in 10:
		await get_tree().process_frame
	await get_tree().create_timer(0.3).timeout
	loadingProgress.value += 15
	for c in booter.get_children():
		c.queue_free()
	loadingProgress.value += 20
	EventBus.assets_loaded.emit()
	self.queue_free()
