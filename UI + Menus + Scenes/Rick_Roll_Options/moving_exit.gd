extends Button

var is_moving = false
var start_position = Vector2()
var target_position = Vector2()
var movement_time = 0.5
var current_time = 0.0
var evasion_distance = 200
var movement_distance = 2

func _ready():
		mouse_filter = Control.MOUSE_FILTER_PASS
		mouse_entered.connect(_on_button_hover)
		mouse_exited.connect(_on_button_unhover)

func _on_button_hover():
		$AnimatedSprite2D.modulate = Color(0.5, 0.5, 0.5, 1.0)

func _on_button_unhover():
		$AnimatedSprite2D.modulate = Color(1, 1, 1, 1)

func _process(delta):
		var mouse_pos = get_viewport().get_mouse_position()
		var button_center = global_position + (size / 2)
		var distance_to_mouse = mouse_pos.distance_to(button_center)
		
		if distance_to_mouse < evasion_distance and not is_moving:
				evade_from_position(mouse_pos)
		
		if is_moving:
				current_time += delta
				var t = current_time / movement_time
				t = smoothstep(0.0, 1.0, t)
				position = start_position.lerp(target_position, t)
				
				if current_time >= movement_time:
						is_moving = false
						current_time = 0.0

func evade_from_position(threat_pos: Vector2):
		start_position = position
		var window_size = get_viewport_rect().size
		var button_size = size
		var direction = (position + size/2 - threat_pos).normalized()
		var valid_position_found = false
		
		for attempt in range(8):
				var random_angle = randf_range(-PI/3, PI/3)
				var escape_direction = direction.rotated(random_angle)
				var potential_target = start_position + (escape_direction * movement_distance)
				
				if is_position_valid(potential_target, window_size, button_size):
						target_position = potential_target
						valid_position_found = true
						break
		
		if not valid_position_found:
				# If no valid position found, move towards the player at double speed and distance
				var towards_player = (threat_pos - (position + size/2)).normalized()
				target_position = start_position + (towards_player * movement_distance * 2)
				movement_time = 0.25  # Double speed (half the time)
		else:
				movement_time = 0.5  # Reset to normal speed if valid position found
		
		is_moving = true
		current_time = 0.0

func is_position_valid(pos: Vector2, window_size: Vector2, button_size: Vector2) -> bool:
		var padding = 10
		return (pos.x >= padding and 
						pos.y >= padding and 
						pos.x + button_size.x <= window_size.x - padding and 
						pos.y + button_size.y <= window_size.y - padding)
