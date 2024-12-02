extends CanvasLayer

# Exported NodePath to the VideoStreamPlayer
@export var video_player_node_path: NodePath = "VideoStreamPlayer"

const VICTORY_THEME = preload("res://Finished_Assets/Song_Assets/Space_Victory_Theme.wav")

func _ready():	# Start the sequence of waiting, playing the video, and crashing the game.
	if Global_Variables.space_win:
		$Node2D/Victory_Theme.stream = VICTORY_THEME
		$Node2D/Victory_Theme.play()
	else:
		$Node2D/AudioStreamPlayer.play()
		$Node2D/AudioStreamPlayer.play()
	start_game_flow()

# Coroutine that handles the game flow
func start_game_flow() -> void:
	await wait_for_seconds(10.0)
	get_tree().change_scene_to_file("res://UI + Menus + Scenes/Gameplay/gameplay_scene.tscn")
	
	#crash_game() # doesn't work yet


# Helper function to wait for a given number of seconds
func wait_for_seconds(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout

func crash_game():
	# Intentionally crash the game by accessing invalid memory (null pointer dereference)
	var invalid_node = null
	invalid_node.call("non_existent_method")
