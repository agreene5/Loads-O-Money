extends CanvasLayer

# Exported NodePath to the VideoStreamPlayer
@export var video_player_node_path: NodePath = "VideoStreamPlayer"

func _ready():	# Start the sequence of waiting, playing the video, and crashing the game.
	start_game_flow()

# Coroutine that handles the game flow
func start_game_flow() -> void:
	await wait_for_seconds(3)

	var video_player = get_node(video_player_node_path) if has_node(video_player_node_path) else null
	if video_player and video_player is VideoStreamPlayer:
		video_player.play()
		print("Video started")
		await wait_for_seconds(5)
		video_player.stop()
		print("Video ended, now crashing the game...")
		crash_game()
	else:
		print("VideoStreamPlayer node not found or not valid!")

# Helper function to wait for a given number of seconds
func wait_for_seconds(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout

# Function to intentionally crash the game
func crash_game():
	# Deliberately crash the game by asserting false
	assert(false, "GET SCAMMED!!!!")
