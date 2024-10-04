# Spawns the tax enemy scenes in the given spawn area at specified rate 
# (depending on the time) as long as it isn't within a building CollisionShape2D
# or within the players CollisionShape2D, "Anti-Spawn_Collision_Area". 
extends Area2D

var rng = RandomNumberGenerator.new()
var timers = []
var sales_tax_scene = preload("res://Tax Enemies/sales_tax.tscn")
var property_tax_scene = preload("res://Tax Enemies/property_tax.tscn")
var income_tax_scene = preload("res://Tax Enemies/income_tax.tscn")

var start_times = [20.0, 33.3, 50.0]
var end_times = [0.1, 0.2, 0.4]
var transition_duration = 900.0  # In 15 minutes the spawning gets pretty much impossible to take on
var transition_start_time = 0.0

func _ready():
	rng.randomize()
	transition_start_time = Time.get_ticks_msec() / 1000.0
	
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
	match timer_index:
		0:
			scene_to_instantiate = sales_tax_scene
		1:
			scene_to_instantiate = property_tax_scene
		2:
			scene_to_instantiate = income_tax_scene
	
	if scene_to_instantiate:
		var instance = scene_to_instantiate.instantiate()
		instance.global_position = spawn_position
		get_tree().root.add_child(instance)

func find_suitable_spawn_point():
	var spawn_area = $Overall_Spawn_Area

	var spawn_shape = spawn_area.shape
	var buildings = []
	for i in range(1, 14):  # Building_1 to Building_13
		var building = get_node_or_null("Building_" + str(i))
		if building and building is CollisionShape2D:
			buildings.append(building)

	var anti_spawn_area = get_node("../Player/Anti-Spawn_Area/Anti-Spawn_Collision_Area")
	var random_point = get_random_point_in_shape(spawn_shape, spawn_area.global_position)

	# Check if the point is inside a building
	for building in buildings:
		if is_point_in_shape(random_point, building):
			return null

	# Check if the point is within the anti-spawn area
	if anti_spawn_area and is_point_in_shape(random_point, anti_spawn_area):
		return null

	return random_point  # Return the point if it's suitable

func get_random_point_in_shape(shape: Shape2D, global_position: Vector2) -> Vector2:
	if shape is RectangleShape2D:
		var rect = Rect2(global_position - shape.extents, shape.extents * 2)
		return Vector2(
			rng.randf_range(rect.position.x, rect.end.x),
			rng.randf_range(rect.position.y, rect.end.y)
		)
	else:
		return global_position

func is_point_in_shape(point: Vector2, shape_node: CollisionShape2D) -> bool:
	if not shape_node or not shape_node.shape:
		return false
	
	var local_point = shape_node.to_local(point)
	return shape_node.shape.collide(Transform2D.IDENTITY, RectangleShape2D.new(), Transform2D(0, local_point))
