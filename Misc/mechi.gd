extends Sprite2D

var lifetime = 5.0
var speed = 2000
var rotation_speed = 5
var direction = Vector2.ZERO
var is_direction_set = false
var player_proximity_threshold = 200.0

func _ready():
		top_level = true
		# Start the despawn timer
		var timer = get_tree().create_timer(lifetime)
		timer.timeout.connect(_on_lifetime_timeout)

func _process(delta):
		# Rotate the sprite
		rotate(rotation_speed * delta)
		
		# Calculate distance to player
		var distance_to_player = global_position.distance_to(Global_Variables.player_position)
		
		# If direction isn't set and we're outside the proximity threshold,
		# keep updating direction towards player
		if !is_direction_set and distance_to_player > player_proximity_threshold:
				direction = (Global_Variables.player_position - global_position).normalized()
		# Once we're within the threshold, lock in the direction
		elif !is_direction_set:
				direction = (Global_Variables.player_position - global_position).normalized()
				is_direction_set = true
		
		# Move in the current direction
		global_position += direction * speed * delta

func _on_lifetime_timeout():
		queue_free()
