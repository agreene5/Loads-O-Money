# Moves camera slightly ahead of player movement and snaps back to the center when player stops
# Also it determines the amount of zoom the camera has initially

extends Camera2D

@export var max_distance: float = 300.0
@export var camera_speed_multiplier: float = 0.25
@export var return_speed: float = 2.0

var target_position: Vector2 = Vector2.ZERO
var tween: Tween

func _ready():
		# Camera doesn't rotate
		set_as_top_level(true)

func _physics_process(delta):
		var player = get_parent()

		var player_velocity = player.linear_velocity
		var player_position = player.global_position

		if player_velocity.length() > 0:
				# Calculate new position based on player's velocity
				var offset = player_velocity.normalized() * min(player_velocity.length() * camera_speed_multiplier, max_distance)
				target_position = player_position + offset
		else:
				# Return to player's position when player is not moving
				target_position = player_position

		# Smoothly move camera to target position
		move_camera_smoothly(target_position)

func move_camera_smoothly(target: Vector2):
		if tween and tween.is_valid():
				tween.kill()

		tween = create_tween()
		tween.set_ease(Tween.EASE_OUT)
		tween.set_trans(Tween.TRANS_CUBIC)
		tween.tween_property(self, "global_position", target, 1.0 / return_speed)
