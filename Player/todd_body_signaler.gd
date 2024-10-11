extends Area2D

@onready var audio_player = AudioStreamPlayer.new()

func _ready():
	await get_tree().create_timer(0.1).timeout # Short delay to prevent immediate dying (not sure why this occurs)
	area_entered.connect(_on_area_entered)
	
	# Set up the AudioStreamPlayer with process mode Always
	audio_player.process_mode = Node.PROCESS_MODE_ALWAYS
	add_child(audio_player)

func _on_area_entered(area):
	Global_Variables.explosion_animation()
	get_tree().paused = true
	
	var parent = get_parent()
	var player_sprite = parent.get_node_or_null("Player_Sprite")
	var shot_sprite = parent.get_node_or_null("Shot_In_Hand_Sprite")
	
	player_sprite.visible = false
	shot_sprite.visible = false
	
	await get_tree().create_timer(0.5).timeout # Wait for explosion animation to finish
	audio_player.stream = load("res://Finished_Assets/Voice_Line_Assets/Death_Voice_Lines_1.wav")
	audio_player.play()
	
	await get_tree().create_timer(3.3).timeout
	get_tree().change_scene_to_file("res://Drowned_Scene.tscn")
	player_sprite.visible = true
	shot_sprite.visible = true
