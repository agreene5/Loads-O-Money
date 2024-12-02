extends AnimatedSprite2D

var rotation_speed = 10  # degrees per second
var abduction_speed = 1200
var escape_speed = 1800
var abduction_timer = 0
var max_abduction_time = 10  # seconds
var is_abducting = false
var target_position = Vector2.ZERO
var moving_to_escape = false
var light_tween: Tween
var black_tween: Tween

var final_velocity = Vector2.ZERO
var caught_timer = 0
var is_caught_moving = false

func _ready():
		# Get the Area2D child and connect its signal
		var area = $Area2D
		area.body_entered.connect(_on_area_2d_area_entered)
		# Initialize UFO_Light to be fully transparent
		$UFO_Light.modulate.a = 0
		play()
		
		Global_Variables.space_abduction_triggered.connect(_on_space_abduction_triggered)

func _process(delta):
		# Constant rotation
		rotation_degrees += rotation_speed * delta
		
		if is_abducting:
				print("is_abducting")
				abduction_timer += delta
				# Update target position to current player position
				target_position = Global_Variables.player_position
				var direction = (target_position - global_position).normalized()
				final_velocity = direction * abduction_speed  # Store the velocity
				global_position += final_velocity * delta
				
				# Check distance to player and handle light modulation
				var distance_to_player = global_position.distance_to(target_position)
				if distance_to_player <= 1000 and $UFO_Light.modulate.a == 0:
						fade_in_light()
				elif distance_to_player > 1000 and $UFO_Light.modulate.a > 0:
						fade_out_light()
				
				# Check if we've run out of time
				if abduction_timer >= max_abduction_time:
						is_abducting = false
						fly_away()
						
		elif is_caught_moving:
				caught_timer += delta
				global_position += final_velocity * delta
				
				if caught_timer >= 5.0:
						is_caught_moving = false
						fly_away()
						
		elif moving_to_escape:
				print("escaping")
				var escape_point = Vector2(6000, 3700)
				var direction = (escape_point - global_position).normalized()
				global_position += direction * escape_speed * delta
				
				# Check if we've reached the escape point
				if global_position.distance_to(escape_point) < 10:
						moving_to_escape = false
						queue_free()

func fade_in_light():
		if light_tween:
				light_tween.kill()
		light_tween = create_tween()
		light_tween.tween_property($UFO_Light, "modulate:a", 1.0, 2.0)

func fade_out_light():
		if light_tween:
				light_tween.kill()
		light_tween = create_tween()
		light_tween.tween_property($UFO_Light, "modulate:a", 0.0, 2.0)
		
func fade_in_black_screen():
		%Black_Screen.visible = true
		if black_tween:
				black_tween.kill()
		black_tween = create_tween()
		black_tween.tween_property(%Black_Screen, "modulate:a", 1.0, 3.0)
		%Black_Screen.visible = false

func _on_space_abduction_triggered():
	abduct_player()

func abduct_player():
		is_abducting = true
		abduction_timer = 0
		target_position = Global_Variables.player_position

func _on_area_2d_area_entered(area):
		if area.name == "Todd_Body_Signaler":
				if is_abducting:
						player_caught()
						is_abducting = false
		
func player_caught():
		%Black_Screen.visible = true
		print("the player has been caught")
		
		var audio_player = $UFO_Audio
		%Player.turn_invisible()
		
		await get_tree().create_timer(0.6).timeout # Wait for explosion animation to finish
		audio_player.stream = load("res://Finished_Assets/Voice_Line_Assets/Death_Voice_Lines/Death_Voice_Lines_1.wav")
		audio_player.volume_db = 5
		audio_player.play()
		await get_tree().create_timer(1.3).timeout
		fade_out_light()
		fade_in_black_screen()
		is_abducting = false
		is_caught_moving = true
		caught_timer = 0
		await get_tree().create_timer(3.0).timeout
		%Spawn_Area.remove_rigid_bodies()
		get_tree().change_scene_to_file("res://UI + Menus + Scenes/Space_Scene/space_scene.tscn")
		%Player.turn_visible()
		
func fly_away():
		moving_to_escape = true
		fade_out_light()
