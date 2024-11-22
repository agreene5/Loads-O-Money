extends RigidBody2D

@onready var path = get_node("../Saul_Path")  # Adjust the path to your Line2D node
@onready var player = get_node("%Player")  # Reference to the player node

var path_points: PackedVector2Array
var current_point := 0
var speed := 200.0  # Adjust this value to control movement speed
var rotation_speed := 5.0  # Adjust this value to control rotation smoothness

var chasing := false
var chase_timer := 0.0
var chase_duration := 3.0

var last_position: Vector2
var stuck_timer := 0.0
var stuck_threshold := 5.0
var min_movement := 1.0

var is_dead := false

func _ready():
		$AnimatedSprite2D.play("riding")
		path_points = path.points
		# Make sure the path has points
		if path_points.size() < 2:
				push_error("Path needs at least 2 points")
				return
		last_position = global_position

func _physics_process(delta):
	var current_pos = global_position
	var direction: Vector2
	var target_point: Vector2

	if is_dead:
		linear_velocity = Vector2.ZERO
		return
	if chasing:
		chase_timer += delta
		if chase_timer >= chase_duration:
			chasing = false
			chase_timer = 0.0
		
		if player:
			direction = (player.global_position - current_pos).normalized()
			target_point = player.global_position
	else:
		if current_point >= path_points.size() - 1:
			current_point = 0  # Loop back to start
		
		target_point = path_points[current_point + 1]
		direction = (target_point - current_pos).normalized()

		# Check if player is within 400 units
		if player and current_pos.distance_to(player.global_position) <= 400:
			chasing = true
			chase_timer = 0.0

	# Calculate target rotation with 90-degree offset
	var target_rotation = direction.angle() + PI/2
	
	# Smoothly rotate towards target rotation
	var current_rotation = rotation
	var rotation_diff = wrapf(target_rotation - current_rotation, -PI, PI)
	rotation = current_rotation + rotation_diff * rotation_speed * delta
	
	# Move towards target point
	linear_velocity = direction * speed
	
	# Check if we're close enough to the current target point (only when not chasing)
	if not chasing and current_pos.distance_to(target_point) < 10:  # Adjust this threshold as needed
		current_point += 1

	check_if_stuck(current_pos, delta)

func check_if_stuck(current_pos: Vector2, delta: float):
	if current_pos.distance_to(last_position) < min_movement:
		stuck_timer += delta
		if stuck_timer >= stuck_threshold:
			teleport_to_nearest_point()
			stuck_timer = 0.0
	else:
		stuck_timer = 0.0
	
	last_position = current_pos

func teleport_to_nearest_point():
		var nearest_point = path_points[0]
		var nearest_distance = global_position.distance_to(path_points[0])
		
		for i in range(1, path_points.size()):
				var distance = global_position.distance_to(path_points[i])
				if distance < nearest_distance:
						nearest_distance = distance
						nearest_point = path_points[i]
						current_point = i
		
		global_position = nearest_point
		print("Teleported to nearest point")

func _on_area_2d_area_entered(area):
	if area.name == "Todd_Body_Signaler":
		if not is_dead:
			is_dead = true
			$AnimatedSprite2D.play("dead")
			$CollisionShape2D.set_deferred("disabled", true)
			$Saul_Death.set_deferred("disabled", true)
			await get_tree().create_timer(5.0).timeout
			$CollisionShape2D.set_deferred("disabled", false)
			$Saul_Death.set_deferred("disabled", false)
			$AnimatedSprite2D.play("riding")
			is_dead = false
	if area.name == "Car_Death_Box":
		if not is_dead:
			is_dead = true
			$AnimatedSprite2D.play("dead")
			$CollisionShape2D.set_deferred("disabled", true)
			$Saul_Death.set_deferred("disabled", true)
			await get_tree().create_timer(3.0).timeout
			$CollisionShape2D.set_deferred("disabled", false)
			$Saul_Death.set_deferred("disabled", false)
			$AnimatedSprite2D.play("riding")
			is_dead = false
