extends Node2D

var original_scale: Vector2
var original_position: Vector2
var original_size: Vector2
var target_size: Vector2
var animation_state: int = 0
var gameplay_scene

func _ready():
		# Reset animation state and other variables
		animation_state = 0
		
		# Reset visibility of nodes if needed
		$Comic.visible = false
		$How_To_Play.visible = false
		
		# Reset animations to their initial state
		$Todd_Animations.stop()
		$Sales_BG.stop()
		$Property_BG.stop()
		
		original_scale = scale
		original_position = position
		original_size = Vector2(
				ProjectSettings.get_setting("display/window/size/viewport_width"),
				ProjectSettings.get_setting("display/window/size/viewport_height")
		)
		target_size = original_size
		
		get_tree().root.size_changed.connect(_on_window_size_changed)
		_on_window_size_changed()
		
		# Start initial animations
		play_first_animations()



func play_first_animations():
	$Todd_Animations.play("How_To_Play")
	$Sales_BG.play("Sales_Tax_BG")
	
	# Wait for both animations to finish
	await $Sales_BG.animation_finished

	# Play the text animation
	$Sales_BG.play("Sales_Tax_Text")

func play_second_animations():
	$Sales_BG.play("Sales_Tax_Disappear")
	$Todd_Animations.play("Transition_To_Second")
	$Property_BG.play("Property_BG")
	
	# Wait for all animations to finish
	await $Property_BG.animation_finished
	
	# Play the text animation
	$How_To_Play.visible = true
	$Property_BG.play("How_To_Play_Text")

func play_final_animations():
	$Property_BG.play("Property_Disappear")
	$Todd_Animations.play("Ending")
	
	await $Property_BG.animation_finished
	
	# Start the comic sequence
	if Global_Variables.game_just_started:
		play_comic_sequence()
		Global_Variables.game_just_started = false
	else:
		get_tree().change_scene_to_file("res://UI + Menus + Scenes/Gameplay/gameplay_scene.tscn")
		

func play_comic_sequence():
		var comic_paths = [
				"res://Finished_Assets/Comic_Assets/Comic1.png",
				"res://Finished_Assets/Comic_Assets/Comic2.png",
				"res://Finished_Assets/Comic_Assets/Comic3.png"
		]
		var comic_voice_lines = [
				Global_Variables.comic_voice_lines[0],
				Global_Variables.comic_voice_lines[1],
				Global_Variables.comic_voice_lines[2]
		]
		
		$Comic.visible = true
		
		for i in range(comic_paths.size()):
				$Comic.texture = load(comic_paths[i])
				$Comic_Voice_Lines.stream = load(comic_voice_lines[i][randi() % comic_voice_lines[i].size()])
				$Comic_Voice_Lines.play()
				
				var time_elapsed = 0.0
				var wait_time = 4.0 if i < comic_paths.size() - 1 else 3.0  # Last comic stays for 3 seconds
				while time_elapsed < wait_time:
						await get_tree().process_frame
						time_elapsed += get_process_delta_time()
						

		$Comic.visible = false
		
		# Transition to gameplay or next scene
		get_tree().change_scene_to_file("res://UI + Menus + Scenes/Gameplay/gameplay_scene.tscn")
	#get_tree().change_scene_to_packed(ResourceLoader.load_threaded_get("res://UI + Menus + Scenes/Gameplay/gameplay_scene.tscn"))

func _input(event):
	if (event.is_action_pressed("ui_accept") or 
		event.is_action_pressed("ui_select") or 
		(event is InputEventMouseButton and event.pressed)):
		
		match animation_state:
			0:  # First sequence
				animation_state = 1
				play_second_animations()
			
			1:  # Second sequence
				animation_state = 2
				play_final_animations()

func _on_window_size_changed():
	var window_size = get_viewport().get_visible_rect().size
	
	# Calculate scale factors for both dimensions separately
	var scale_x = window_size.x / original_size.x
	var scale_y = window_size.y / original_size.y
	
	# Apply different scaling for each axis
	scale = Vector2(scale_x, scale_y) * original_scale
	
	# Update position to center the content
	position = original_position * Vector2(scale_x, scale_y)
