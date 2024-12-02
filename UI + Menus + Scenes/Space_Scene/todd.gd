extends Area2D

var speed = 1000  # Reduced speed for smoother movement
var chase_range = 1500  # Distance at which the enemy starts chasing
var is_chasing = false  # Flag to check if currently chasing

func _process(delta):
	# Get the player's position from Global_Variables
	var player_pos = Global_Variables.player_position_space
	
	# Calculate distance to player
	if player_pos:
		var distance_to_player = global_position.distance_to(player_pos)
		
		# If within chase range
		if distance_to_player <= chase_range:
			if not is_chasing:
				# Start chasing
				is_chasing = true
				in_range()
			
			# Calculate direction to player
			var direction = (player_pos - global_position).normalized()
			
			# Move towards player
			global_position += direction * speed * delta
		
		# If the player leaves the chase range, stop chasing
		elif is_chasing:
			is_chasing = false

# Function that gets called when the player is within range
func in_range():
	$AudioStreamPlayer.play()
