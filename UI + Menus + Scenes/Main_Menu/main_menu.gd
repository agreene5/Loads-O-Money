extends Control

var quit_audio: AudioStreamPlayer
var play_audio: AudioStreamPlayer
@onready var logo_quarter = $Container/Logo_Quarter
@onready var dlc_button = $Container/Button_Sprites/DLC
@onready var animation_player = $AnimationPlayer
func _on_play_pressed() -> void:
	play_audio.play()
	TransitionScene.transition()
	await TransitionScene.on_transition_finished
	get_tree().change_scene_to_file("res://UI + Menus + Scenes/Gameplay/gameplay_scene.tscn")
	
	


func _on_options_pressed() -> void:
	get_tree().change_scene_to_file("res://UI + Menus + Scenes/Options_Menu/options_menu.tscn")

func _on_dlc_pressed() -> void:
	
	animation_player.play("coin_expand")
	await get_tree().create_timer(2).timeout
	TransitionScene.transition()
	await TransitionScene.on_transition_finished
	get_tree().change_scene_to_file("res://UI + Menus + Scenes/Rick_Roll_Options/rick_roll.tscn")

func _on_quit_pressed() -> void:
	quit_audio.play()
	TransitionScene.transition()
	await quit_audio.finished
	
	get_tree().quit()

func _ready():
	# Preload the audio files
	var quit_sfx = preload("res://Temp_Assets/Temp_SFX_Assets/Aah_Roland169.mp3")
	var play_sfx = preload("res://Temp_Assets/Temp_SFX_Assets/Cha-Ching-SFX.mp3")
	
	# Create AudioStreamPlayer nodes
	quit_audio = AudioStreamPlayer.new()
	play_audio = AudioStreamPlayer.new()
	
	# Set the audio streams
	quit_audio.stream = quit_sfx
	play_audio.stream = play_sfx
	
	# Add the audio players as children of the current node
	add_child(quit_audio)
	add_child(play_audio)
