extends Button

func _ready():
		# Connect the signals
		mouse_entered.connect(_on_button_hover)
		mouse_exited.connect(_on_button_unhover)

func _on_button_hover():
		# Tint the sprite 50% black when hovered
		%Play_Button_Sprite.modulate = Color(0.5, 0.5, 0.5, 1.0)


func _on_button_unhover():
		# Return sprite to normal color
		%Play_Button_Sprite.modulate = Color(1, 1, 1, 1)
