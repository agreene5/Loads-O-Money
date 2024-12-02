extends Node2D

var original_scale: Vector2
var original_position: Vector2
var original_size: Vector2

func _ready():
		# Original window sizing code setup
		original_scale = scale
		original_position = position
		original_size = Vector2(
			ProjectSettings.get_setting("display/window/size/viewport_width"),
			ProjectSettings.get_setting("display/window/size/viewport_height")
		)
		
		# Store initial positions BEFORE connecting the size changed signal
		store_initial_positions("Upgrade_Menu_Open")
		store_initial_positions("Upgrade_Menu_Close")
		
		# Now connect the signal and do initial scaling
		get_tree().root.size_changed.connect(_on_window_size_changed)
		# Call this after storing positions
		call_deferred("_on_window_size_changed")
	
	# Rest of your ready function...

		if Global_Variables.game_just_just_started:
			_play_bootscreen()
		else:
			$Main_Menu_Theme.play()
		Global_Variables.game_just_just_started = false
		store_initial_positions("Upgrade_Menu_Open")
		store_initial_positions("Upgrade_Menu_Close")
		
func _play_bootscreen():
	var voice_player = $Bootscreen_Voicelines
	var video_audio = $Bootscreen_Vid_SFX
	var color_rect = $ColorRect
	
	# Start loading the voice line in background
	var random_voice_line = Global_Variables.bootscreen_voice_lines[randi() % Global_Variables.bootscreen_voice_lines.size()]
	ResourceLoader.load_threaded_request(random_voice_line)
	
	# Show and play the video immediately
	$Bootscreen_Vid.visible = true
	color_rect.visible = true
	$Bootscreen_Vid.play()
	video_audio.play()
	
	# Wait until voice line is loaded
	while ResourceLoader.load_threaded_get_status(random_voice_line) != ResourceLoader.THREAD_LOAD_LOADED:
		await get_tree().process_frame
	
	# Play the loaded voice line
	voice_player.stream = ResourceLoader.load_threaded_get(random_voice_line)
	voice_player.volume_db = 2
	voice_player.play()
	
	# Rest of your function remains the same
	await get_tree().create_timer(4.4).timeout
	
	$Bootscreen_Vid.visible = false
	$Bootscreen_Vid.stop()
	
	var duration = 1.5
	var fade_time = 0.0
	$Main_Menu_Theme.play()

	while fade_time < duration:
		fade_time += get_process_delta_time()
		var alpha = lerp(1.0, 0.0, fade_time / duration)
		color_rect.modulate.a = alpha
		await get_tree().process_frame

	color_rect.modulate.a = 0.0
	color_rect.visible = false

@onready var animation_player = $Upgrade_Menu_Transition  # Make sure this points to your AnimationPlayer

# Store the original animation values
var original_open_animation_values = {}
var original_close_animation_values = {}


func store_original_animation_values(animation_name: String, storage_dict: Dictionary):
	var animation = animation_player.get_animation(animation_name)
	for track_idx in animation.get_track_count():
		var path = animation.track_get_path(track_idx)
		storage_dict[path] = []
		for key_idx in animation.track_get_key_count(track_idx):
			storage_dict[path].append(animation.track_get_key_value(track_idx, key_idx))

func _on_window_size_changed():
	var window_size = get_viewport().get_visible_rect().size
	var scale_x = window_size.x / original_size.x
	var scale_y = window_size.y / original_size.y
	
	scale = Vector2(scale_x, scale_y) * original_scale
	position = original_position * Vector2(scale_x, scale_y)
	
	# Update animations
	scale_animation("Upgrade_Menu_Open", original_open_animation_values, scale_x, scale_y)
	scale_animation("Upgrade_Menu_Close", original_close_animation_values, scale_x, scale_y)

var initial_positions = {}

func store_initial_positions(animation_name: String):
	var animation = animation_player.get_animation(animation_name)
	initial_positions[animation_name] = []
	
	for track_idx in animation.get_track_count():
		var path = animation.track_get_path(track_idx)
		var property = str(path).split(":")[-1]
		
		if "position" in property.to_lower():
			var key_positions = []
			for key_idx in animation.track_get_key_count(track_idx):
				key_positions.append(animation.track_get_key_value(track_idx, key_idx))
			initial_positions[animation_name].append({
				"track": track_idx,
				"positions": key_positions
			})

func scale_animation(animation_name: String, original_values: Dictionary, scale_x: float, scale_y: float):
	if not animation_name in initial_positions:
		return
		
	var animation = animation_player.get_animation(animation_name)
	for track_data in initial_positions[animation_name]:
		var track_idx = track_data["track"]
		var positions = track_data["positions"]
		
		for key_idx in positions.size():
			var initial_value = positions[key_idx]
			if initial_value is Vector2:
				var scaled_value = Vector2(
					initial_value.x * scale_x,
					initial_value.y * scale_y
				)
				animation.track_set_key_value(track_idx, key_idx, scaled_value)
