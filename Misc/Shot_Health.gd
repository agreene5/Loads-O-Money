extends Area2D

# Dictionary containing health values for different shot types
var SHOT_HEALTH = Global_Variables.SHOT_HEALTH

var current_health: float = 0.0

func despawn():
	if current_health <= 0:
		print("Despawning ", name)
		get_parent().queue_free()

func _ready():
	# Check if the exact node name exists
	if SHOT_HEALTH.has(name):
		current_health = SHOT_HEALTH[name]
	else:
		push_warning("Shot type not found for node: " + name)
	
	area_entered.connect(_on_area_entered)

func _on_area_entered(area):
	if area.has_method("receive_value"):
		var result = Global_Variables.calculate_difference(current_health, area.get_value())
		if self.get_instance_id() < area.get_instance_id():
			area.receive_value(result)
			current_health = current_health - result
			despawn()

func get_value():
	return current_health

func receive_value(value):
	var new_health = current_health - value
	print(name, " health: ", current_health, " New health: ", new_health)
	current_health = new_health
	despawn()
