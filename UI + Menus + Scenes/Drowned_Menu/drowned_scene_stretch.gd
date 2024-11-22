# This script plays some sfx and then changes back to the gameplay scene

extends Control

@onready var texture_rect = $TextureRect
@onready var audio_player = AudioStreamPlayer.new()

func _ready():
	get_tree().root.size_changed.connect(_on_viewport_size_changed)
	_on_viewport_size_changed()
	
	add_child(audio_player)
	audio_player.stream = load("res://Finished_Assets/SFX_Assets/Taco_Bell_SFX.mp3")
	audio_player.play()
	ResourceLoader.load_threaded_request("res://UI + Menus + Scenes/Gameplay/gameplay_scene.tscn")
	await get_tree().create_timer(1.9).timeout
	
	get_tree().paused = false
	get_tree().change_scene_to_packed(ResourceLoader.load_threaded_get("res://UI + Menus + Scenes/Gameplay/gameplay_scene.tscn"))

func _on_viewport_size_changed():
	texture_rect.size = get_viewport_rect().size
