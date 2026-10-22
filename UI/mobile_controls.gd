extends Node2D

@onready var touchButtons = $TouchScreenControls

func _ready() -> void:
	# Check if the device is mobile (Android / iOS) or Web mobile
	if OS.has_feature("mobile") or OS.has_feature("web_android") or OS.has_feature("web_ios"):
		touchButtons.show() # Keep the mobile UI visible
	else:
		touchButtons.hide() # Hide it completely for PC/Mac/Linux/Web Desktop
