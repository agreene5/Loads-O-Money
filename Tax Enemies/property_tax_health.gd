extends Area2D

@export var property_health = 15

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area_entered.connect(_on_area_entered)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func get_value():
	return property_health

func receive_value(value):
	print("ENEMY  health: ", property_health, " New health: ", property_health+value)

func despawn():
		queue_free()

func _on_area_entered(area):
	if area.has_method("get_value"):
		var result = Global_Variables.calculate_difference(property_health, area.get_value())
		#Play hit sfx 
		#Have tax enemy die and play explosion animation and sfx if health is less than or equal to 0
		if self.get_instance_id() < area.get_instance_id():
			area.receive_value(result)
			receive_value(-result)
			property_health = property_health - result
			if(property_health <= 0):
				print("property tax died")
				despawn()
	
