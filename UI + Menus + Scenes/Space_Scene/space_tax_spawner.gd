extends Node2D

@export var point1: Vector2  # First corner of the rectangle
@export var point2: Vector2  # Second corner of the rectangle

var spawn_timer: Timer
var validation_area: Area2D
var collision_shape: CollisionShape2D
var is_area_occupied: bool = false

@export var base_min_spawn_distance: float = 1000  # Minimum spawn distance at low speed
@export var base_max_spawn_distance: float = 2000  # Maximum spawn distance at low speed
@export var max_player_speed: float = 1000        # Maximum player speed used for scaling

func _ready():
		# Create and setup the timer
		spawn_timer = Timer.new()
		add_child(spawn_timer)
		spawn_timer.wait_time = 5.0
		spawn_timer.connect("timeout", _on_spawn_timer_timeout)
		spawn_timer.start()
		
		# Create validation Area2D
		validation_area = Area2D.new()
		collision_shape = CollisionShape2D.new()
		var shape = RectangleShape2D.new()
		shape.size = Vector2(10, 10)
		collision_shape.shape = shape
		validation_area.add_child(collision_shape)
		add_child(validation_area)
		
		# Connect area signals
		validation_area.connect("area_entered", _on_validation_area_entered)
		validation_area.connect("body_entered", _on_validation_area_entered)
		
		decrease_spawn_time()

func _on_spawn_timer_timeout():
		attempt_spawn()

func attempt_spawn():
		var valid_point = await find_valid_spawn_point()
		if valid_point != null:
				spawn_object(valid_point)

func find_valid_spawn_point():
		var max_attempts = 10  # Prevent infinite loops
		var attempts = 0
		
		# Get player's position and velocity
		var player = get_node("%Space_Player")
		var player_position = Global_Variables.player_position_space
		if player_position == null:
				player_position = player.global_position  # Fallback to player's global position
		var player_velocity = player.velocity if player.has_method("velocity") else Vector2.ZERO
		var player_speed = player_velocity.length()
		
		# Enforce a minimum speed for directional spawning
		if player_speed < 1:  # If the player is stationary or moving very slowly
				player_velocity = Vector2.UP  # Default to an upward direction
				player_speed = 0  # No speed scaling for spawn radius
		
		# Adjust spawn radius based on player speed
		var min_spawn_distance = base_min_spawn_distance
		var max_spawn_distance = base_max_spawn_distance + player_speed * 2
		
		# Normalize the player's velocity for direction
		var spawn_direction = player_velocity.normalized()
		
		while attempts < max_attempts:
				# Generate random spawn distance and angle
				var random_distance = randf_range(min_spawn_distance, max_spawn_distance)
				var random_angle = randf_range(-45, 45) * PI / 180  # Convert degrees to radians
				var spawn_offset = spawn_direction.rotated(random_angle) * random_distance
				
				# Calculate the test spawn point
				var test_point = player_position + spawn_offset
				
				# Ensure the point is valid
				if await is_point_valid(test_point):
						return test_point
				
				attempts += 1
		
		return null  # No valid point found

func is_point_valid(point: Vector2) -> bool:
		is_area_occupied = false
		validation_area.position = point
		
		# Wait a brief moment to allow physics to update
		await get_tree().create_timer(0.1).timeout
		
		return !is_area_occupied

func _on_validation_area_entered(_body_or_area):
		is_area_occupied = true

func spawn_object(spawn_position: Vector2):
		print('Spawning space tax')
		var space_tax_scene = preload("res://UI + Menus + Scenes/Space_Scene/space_tax_special.tscn")
		var space_tax_instance = space_tax_scene.instantiate()
		space_tax_instance.position = spawn_position
		add_child(space_tax_instance)

func decrease_spawn_time():
		var initial_wait_time = 8.0
		var final_wait_time = 1.0
		var transition_duration = 100.0
		
		var tween = create_tween()
		tween.tween_method(
				func(value: float): spawn_timer.wait_time = value,
				initial_wait_time,
				final_wait_time,
				transition_duration
		)
