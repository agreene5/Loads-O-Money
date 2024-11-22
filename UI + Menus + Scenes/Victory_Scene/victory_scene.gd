extends CanvasLayer

# Exported NodePath to the VideoStreamPlayer
@export var video_player_node_path: NodePath = "VideoStreamPlayer"

func _ready():	# Start the sequence of waiting, playing the video, and crashing the game.
	start_game_flow()

# Coroutine that handles the game flow
func start_game_flow() -> void:
	await wait_for_seconds(10.0)
	crash_game()


# Helper function to wait for a given number of seconds
func wait_for_seconds(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout

func crash_game():
	# Intentionally crash the game by accessing invalid memory (null pointer dereference)
	var invalid_node = null
	invalid_node.call("non_existent_method")
