extends Button

func _ready():
		# Connect the signals
		mouse_entered.connect(_on_button_hover)
		mouse_exited.connect(_on_button_unhover)

func _on_pressed() -> void:
	get_parent().get_parent().upgrade_menu()

func _on_button_hover():
		Global_Variables.button_hovered = true
		# Tint the sprite 50% black when hovered
		%Animated_MoneyBag.modulate = Color(0.5, 0.5, 0.5, 1.0)


func _on_button_unhover():
		Global_Variables.button_hovered = false
		# Return sprite to normal color
		%Animated_MoneyBag.modulate = Color(1, 1, 1, 1)
