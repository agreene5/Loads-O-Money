extends Control

var quit_audio: AudioStreamPlayer
var play_audio: AudioStreamPlayer

func _on_play_pressed() -> void:
	play_audio.play()
	await get_tree().create_timer(1.5).timeout
	get_tree().change_scene_to_file("res://UI + Menus + Scenes/How_To_Play_Scene/how_to_play.tscn")



func _on_options_pressed() -> void:
	print("open")
	$Container/Upgrade_Menu_Transition.play("Upgrade_Menu_Open")

func _on_dlc_pressed() -> void:
	get_tree().change_scene_to_file("res://UI + Menus + Scenes/Rick_Roll_Options/rick_roll.tscn")

func _on_quit_pressed() -> void:
	quit_audio.play()
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


func _on_back_pressed():
	print("back")
	$Container/Upgrade_Menu_Transition.play("Upgrade_Menu_Close")
