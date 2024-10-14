# Spawns the tax enemy scenes in the given spawn area at specified rate 
# (depending on the time) as long as it isn't within a building CollisionShape2D
# or within the players CollisionShape2D, "Anti-Spawn_Collision_Area". 
extends Area2D

var rng = RandomNumberGenerator.new()
var timers = []
var sales_tax_scene = preload("res://Tax Enemies/sales_tax.tscn")
var property_tax_scene = preload("res://Tax Enemies/property_tax.tscn")
var income_tax_scene = preload("res://Tax Enemies/income_tax.tscn")
var start_times = [15.0, 25.0, 37.5]
var end_times = [0.1, 0.2, 0.4]
var transition_duration = 600.0  # In 10 minutes the spawning gets pretty much impossible to take on
var transition_start_time = 0.0

func _ready():
	rng.randomize()
	transition_start_time = Time.get_ticks_msec() / 1000.0
	
	# Remove all RigidBody2D nodes except the Player
	remove_rigid_bodies()
	
	for i in range(3):
		var timer = Timer.new()
		add_child(timer)
		timer.one_shot = false
		timer.timeout.connect(_on_Timer_timeout.bind(i))
		timer.start(start_times[i])
		timers.append(timer)
		
		# Start the timer with the initial wait time
		timer.wait_time = start_times[i]
	set_process(true)

func remove_rigid_bodies():
	# Get the main scene node (parent of this node's parent)
	var main_scene = get_parent().get_parent()
		
		# Use a stack to replace the recursive approach
	var stack = [main_scene]
		
	while stack:
		var current_node = stack.pop_front()  # Treat the list as a stack
		
		# We process all children of the current node
		for child in current_node.get_children():
			if child is RigidBody2D and "Tax" in child.name:
				# Free the node if it's a RigidBody2D (except the Player)
				child.queue_free()
			else:
				# Otherwise, add this child to the stack to process its children
				stack.append(child)




func _process(delta):
	update_timers()

func update_timers():
	var current_time = Time.get_ticks_msec() / 1000.0
	var elapsed_time = current_time - transition_start_time
	
	if elapsed_time < transition_duration:
		for i in range(3):
			var progress = elapsed_time / transition_duration
			progress = clamp(progress, 0.0, 1.0)
			var new_wait_time = lerp(start_times[i], end_times[i], progress)
			timers[i].wait_time = new_wait_time
	else:
		for i in range(3):
			timers[i].wait_time = end_times[i]

func _on_Timer_timeout(timer_index):
	var point_found = false
	var spawn_position
	while not point_found:
		spawn_position = find_suitable_spawn_point()
		if spawn_position:
			point_found = true
	
	var scene_to_instantiate
	var scene_name
	match timer_index:
		0:
			scene_to_instantiate = sales_tax_scene
			scene_name = "Sales_Tax"
		1:
			scene_to_instantiate = property_tax_scene
			scene_name = "Property_Tax"
		2:
			scene_to_instantiate = income_tax_scene
			scene_name = "Income_Tax"
	
	if scene_to_instantiate:
		var instance = scene_to_instantiate.instantiate()
		instance.global_position = spawn_position
		instance.name = scene_name + "_" + str(rng.randi())  # Add a unique identifier
		get_tree().root.add_child(instance)
		print("Spawned: ", instance.name)  # Print the name of the spawned instance

func find_suitable_spawn_point():
	var spawn_area = $Overall_Spawn_Area
	var spawn_shape = spawn_area.polygon
	var buildings = []
	for i in range(1, 20):  # Building_1 to Building_19
		var building = get_node_or_null("Building_Group_" + str(i))
		if building and building is CollisionPolygon2D:
			buildings.append(building)
	var anti_spawn_area = get_node("../Player/Anti-Spawn_Area/Anti-Spawn_Collision_Area")
	
	var random_point = get_random_point_in_polygon(spawn_shape, spawn_area.global_position)
	
	# Check if the point is inside a building
	for building in buildings:
		if is_point_in_polygon(random_point, building):
			return null
	
	# Check if the point is within the anti-spawn area
	if anti_spawn_area:
		if anti_spawn_area is CollisionShape2D:
			if is_point_in_shape(random_point, anti_spawn_area):
				return null
		elif anti_spawn_area is CollisionPolygon2D:
			if is_point_in_polygon(random_point, anti_spawn_area):
				return null
	
	return random_point  # Return the point if it's suitable

func get_random_point_in_polygon(polygon: PackedVector2Array, global_position: Vector2) -> Vector2:
	var bbox = Rect2()
	for point in polygon:
		bbox = bbox.expand(point)
	
	var max_attempts = 100  # Prevent infinite loop
	for i in range(max_attempts):
		var point = Vector2(
			rng.randf_range(bbox.position.x, bbox.end.x),
			rng.randf_range(bbox.position.y, bbox.end.y)
		)
		if Geometry2D.is_point_in_polygon(point, polygon):
			return global_position + point
	
	# If we couldn't find a point after max_attempts, return the center of the bounding box
	return global_position + bbox.get_center()

func is_point_in_polygon(point: Vector2, polygon_node: CollisionPolygon2D) -> bool:
	if not polygon_node:
		return false
	
	var local_point = polygon_node.to_local(point)
	var polygon = polygon_node.polygon
	
	return Geometry2D.is_point_in_polygon(local_point, polygon)

func is_point_in_shape(point: Vector2, shape_node: CollisionShape2D) -> bool:
	if not shape_node or not shape_node.shape:
		return false
	
	var local_point = shape_node.to_local(point)
	return shape_node.shape.collide(Transform2D.IDENTITY, shape_node.shape, Transform2D(0, local_point))
