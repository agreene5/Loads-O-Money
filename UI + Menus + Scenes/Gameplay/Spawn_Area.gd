# Spawns the tax enemy scenes in the given spawn area at specified rate 
# (depending on the time) as long as it isn't within a building CollisionShape2D
# or within the players CollisionShape2D, "Anti-Spawn_Collision_Area". 
extends Area2D

var rng = RandomNumberGenerator.new()
var timers = []
var sales_tax_scene = preload("res://Tax Enemies/sales_tax.tscn")
var property_tax_scene = preload("res://Tax Enemies/property_tax.tscn")
var income_tax_scene = preload("res://Tax Enemies/income_tax.tscn")

# Modified timing values
var start_times = [10.0, 25.0, 37.5]  # Initial spawn rates
var end_times = [1.5, 0.6, 0.25]       # Final spawn rates
var enemy_unlock_times = [0.0, 60.0, 150.0]  # When each enemy type unlocks
var game_start_time = 0.0
var transition_duration
var transition_start_time = 0.0

func _ready():
		transition_duration = get_parent().stat_progression_time
		game_start_time = Time.get_ticks_msec() / 1000.0
		
		rng.randomize()
		transition_start_time = game_start_time
		
		remove_rigid_bodies()
		
		# Spawn initial sales tax
		var spawn_position = find_suitable_spawn_point()
		if spawn_position:
				var instance = sales_tax_scene.instantiate()
				instance.global_position = spawn_position
				instance.name = "Sales_Tax_" + str(rng.randi())
				get_tree().root.add_child(instance)
		
		for i in range(3):
				var timer = Timer.new()
				add_child(timer)
				timer.one_shot = false
				timer.timeout.connect(_on_Timer_timeout.bind(i))
				timer.wait_time = start_times[i]
				timer.start()
				timers.append(timer)

		set_process(true)

func update_timers():
		var current_time = Time.get_ticks_msec() / 1000.0
		var elapsed_time = current_time - transition_start_time
		var game_elapsed_time = current_time - game_start_time
		
		if elapsed_time < transition_duration:
				for i in range(3):
						# Only update timer if this enemy type is unlocked
						if game_elapsed_time >= enemy_unlock_times[i]:
								var progress = elapsed_time / transition_duration
								progress = clamp(progress, 0.0, 1.0)
								
								# Modify spawn rates based on enemy type
								var new_wait_time
								match i:
										0:  # Sales tax (becomes less common)
												new_wait_time = lerp(start_times[i], end_times[i] * 2.0, progress)
										1:  # Property tax (becomes slightly less common)
												new_wait_time = lerp(start_times[i], end_times[i] * 1.5, progress)
										2:  # Income tax (maintains regular progression)
												new_wait_time = lerp(start_times[i], end_times[i], progress)
								
								timers[i].wait_time = new_wait_time

func _on_Timer_timeout(timer_index):
		var current_time = Time.get_ticks_msec() / 1000.0
		var game_elapsed_time = current_time - game_start_time
		
		# Check if this enemy type should spawn yet
		if game_elapsed_time < enemy_unlock_times[timer_index]:
				return
				
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
		var player = get_node("../Player")
		
		# Get the viewport size
		var viewport_size = get_viewport().get_visible_rect().size
		var camera = get_viewport().get_camera_2d()
		var camera_zoom = camera.zoom if camera else Vector2(1, 1)
		
		var max_attempts = 100
		for attempt in range(max_attempts):
				# Generate a random angle and distance (between 600 and 1000 units from player)
				var angle = rng.randf() * 2 * PI
				var distance = rng.randf_range(viewport_size.length() / 2.0, 1000.0)
				
				# Calculate potential spawn position relative to player
				var offset = Vector2(cos(angle), sin(angle)) * distance
				var random_point = player.global_position + offset
				
				# Check if point is within spawn area
				if not Geometry2D.is_point_in_polygon(spawn_area.to_local(random_point), spawn_shape):
						continue
				
				# Check if point is visible in viewport
				var point_in_view = Rect2(
						player.global_position - (viewport_size * 0.5 / camera_zoom),
						viewport_size / camera_zoom
				).has_point(random_point)
				
				if point_in_view:
						continue
				
				# Check if the point is inside a building
				var valid_position = true
				for building in buildings:
						if is_point_in_polygon(random_point, building):
								valid_position = false
								break
				
				if not valid_position:
						continue
				
				# Check if the point is within the anti-spawn area
				if anti_spawn_area:
						if anti_spawn_area is CollisionShape2D:
								if is_point_in_shape(random_point, anti_spawn_area):
										continue
						elif anti_spawn_area is CollisionPolygon2D:
								if is_point_in_polygon(random_point, anti_spawn_area):
										continue
				
				return random_point  # Return the point if it's suitable
		
		# If we couldn't find a point after max_attempts, return null
		return null

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
