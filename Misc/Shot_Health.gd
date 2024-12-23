extends Area2D

# Dictionary containing health values for different shot types
var SHOT_HEALTH = Global_Variables.SHOT_HEALTH

var current_health: float = 0 

func despawn():
	if current_health <= 0:
		print("Despawning")
		get_parent().queue_free()

func _ready():
	current_health = SHOT_HEALTH[name]

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
	current_health = new_health
	despawn()
