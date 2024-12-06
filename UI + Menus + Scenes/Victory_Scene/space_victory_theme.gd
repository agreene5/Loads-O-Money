extends AudioStreamPlayer

var input_allowed = false

func _ready():
		Global_Variables.star_3 = true
		await get_tree().create_timer(2.3).timeout
		play()
		input_allowed = true
		# Create timer but don't await it immediately
		var timer = get_tree().create_timer(87.7)
		timer.timeout.connect(_on_timer_timeout)
		

func _input(event):
		if input_allowed:
			if event is InputEventMouseButton and event.pressed:
					var main_menu = load("res://UI + Menus + Scenes/Main_Menu/main_menu.tscn")
					get_tree().change_scene_to_packed(main_menu)

func _on_timer_timeout():
		var main_menu = load("res://UI + Menus + Scenes/Main_Menu/main_menu.tscn")
		get_tree().change_scene_to_packed(main_menu)
