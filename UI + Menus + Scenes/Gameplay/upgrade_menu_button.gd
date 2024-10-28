extends Button

@onready var upgrade_menu = $"../UpgradeMenu"

var paused = false


func _on_pressed() -> void:
	upgradeMenu()

func upgradeMenu():
	if paused:
		upgrade_menu.hide()
		Engine.time_scale =1
	else:
		upgrade_menu.show()
		Engine.time_scale =0
	paused = !paused
