extends CanvasLayer

var input_allowed = false

func _ready():	
	Global_Variables.star_1 = true
	get_tree().paused = true
	await get_tree().create_timer(3.03).timeout
	$Node2D/BillionareText.visible = false
	input_allowed = true
	var timer = get_tree().create_timer(150.0)
	timer.timeout.connect(_on_timer_timeout)

func _input(event):
	if input_allowed:
		if event is InputEventMouseButton and event.pressed:
				_change_to_victory_scene()

func _change_to_victory_scene():
		var victory_scene = load("res://UI + Menus + Scenes/Main_Menu/main_menu.tscn")
		get_tree().change_scene_to_packed(victory_scene)

func _on_timer_timeout():
		_change_to_victory_scene()
