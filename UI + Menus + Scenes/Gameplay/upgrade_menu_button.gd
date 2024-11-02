extends Button

func on_ready():
	visible = false

func _on_pressed() -> void:
	owner.upgrade_menu()
