extends Control

var quit_audio: AudioStreamPlayer
var play_audio: AudioStreamPlayer
var dlc_audio: AudioStreamPlayer
@onready var dlc_button = $Container/Button_Sprites/DLC
@onready var animation_player = $AnimationPlayer

var voice_line_timer: Timer
var is_playing_voice_lines: bool = false

func _on_play_pressed() -> void:
	play_audio.play()

	TransitionScene.transition()
	await TransitionScene.on_transition_finished
	if Global_Variables.game_just_started:
		get_tree().change_scene_to_file("res://UI + Menus + Scenes/How_To_Play_Scene/how_to_play.tscn")
	else:
		get_tree().change_scene_to_file("res://UI + Menus + Scenes/Gameplay/gameplay_scene.tscn")

func _play_random_voice_line() -> void:
	if is_playing_voice_lines:
		var random_index = randi() % Global_Variables.todd_random_voice_lines.size()
		%Random_Todd_Lines.stream = load(Global_Variables.todd_random_voice_lines[random_index])
		%Random_Todd_Lines.play()

func _on_options_pressed() -> void:
	# Create tween that processes even when paused
	var tween = create_tween().set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	
	# Fade out Gameplay theme
	tween.parallel().tween_property(%Main_Menu_Theme, "volume_db", -30.0, 1.0)
	# Fade in Pause theme
	tween.parallel().tween_property(%British_Music, "volume_db", -2.0, 1.0)
	%British_Music.play()
	
	$Container/Upgrade_Menu_Transition.play("Upgrade_Menu_Open")
	is_playing_voice_lines = true
	await get_tree().create_timer(3.0).timeout
	
	# Start playing random voice lines
	_play_random_voice_line() # Play first voice line immediately
	voice_line_timer.start() # Start timer for subsequent voice lines

	

func _on_dlc_pressed() -> void:
	dlc_audio.play()
	animation_player.play("coin_expand")
	$Container/Logo_Video_Sprites/Logo_Quarter.z_index = 1
	await get_tree().create_timer(1.0).timeout
	TransitionScene.transition()
	await TransitionScene.on_transition_finished
	get_tree().change_scene_to_file("res://UI + Menus + Scenes/Rick_Roll_Options/rick_roll.tscn")
	$Container/Logo_Video_Sprites/Logo_Quarter.z_index = 0

func _on_quit_pressed() -> void:
	quit_audio.play()
	TransitionScene.transition()
	await quit_audio.finished
	
	get_tree().quit()


func _ready():
	# Preload the audio files
	var quit_sfx = preload("res://Temp_Assets/Temp_SFX_Assets/Aah_Roland169.mp3")
	var play_sfx = preload("res://Temp_Assets/Temp_SFX_Assets/Cha-Ching-SFX.mp3")
	var dlc_sfx = preload("res://Temp_Assets/Temp_SFX_Assets/Suspense_Dun_SFX.mp3")
	
	# Create AudioStreamPlayer nodes
	quit_audio = AudioStreamPlayer.new()
	play_audio = AudioStreamPlayer.new()
	dlc_audio = AudioStreamPlayer.new()
	
	quit_audio.bus = "SFX"
	play_audio.bus = "SFX"
	dlc_audio.bus = "SFX"
	
	quit_audio.volume_db += 2
	quit_audio.volume_db += 2
	quit_audio.volume_db += 5

	# Set the audio streams
	quit_audio.stream = quit_sfx
	play_audio.stream = play_sfx
	dlc_audio.stream = dlc_sfx
	
	# Add the audio players as children of the current node
	add_child(quit_audio)
	add_child(play_audio)
	add_child(dlc_audio)

	# Create and configure the timer
	voice_line_timer = Timer.new()
	voice_line_timer.wait_time = 8.0
	voice_line_timer.connect("timeout", _play_random_voice_line)
	add_child(voice_line_timer)


func _on_back_pressed():
	var tween = create_tween().set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	
	# Fade in Gameplay theme
	tween.parallel().tween_property(%Main_Menu_Theme, "volume_db", 0.0, 1.0)
	# Fade out Pause theme
	tween.parallel().tween_property(%British_Music, "volume_db", -30.0, 1.0)
	
	$Container/Upgrade_Menu_Transition.play("Upgrade_Menu_Close")
	# Stop playing voice lines
	is_playing_voice_lines = false
	voice_line_timer.stop()
	%Random_Todd_Lines.stop()
	
	$Container/Upgrade_Menu_Transition.play("Upgrade_Menu_Close")
