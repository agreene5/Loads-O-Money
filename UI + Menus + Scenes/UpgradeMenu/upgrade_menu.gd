extends Control

@onready var upgrade_menu = $"../UpgradeMenu"


func _process(delta: float) -> void:
	pass





func _on_exit_button_pressed() -> void:
	upgrade_menu.hide()
	Engine.time_scale =1


func _on_upgrade_coin_button_pressed() -> void:
	pass


func _on_upgrade_bill_button_pressed() -> void:
	pass # Replace with function body.


func _on_upgrade_check_button_pressed() -> void:
	pass # Replace with function body.
