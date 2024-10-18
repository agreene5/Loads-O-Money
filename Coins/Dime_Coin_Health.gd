extends Area2D

@export var dime_health = 8.0

# Global Variable script refernece for calculating shot health
func _ready():
	area_entered.connect(_on_area_entered)
	if dime_health <=0:
		queue_free()
	
func _on_area_entered(area):
	if area.has_method("receive_value"):
		var result = Global_Variables.calculate_difference(dime_health, area.get_value())
		
		if self.get_instance_id() < area.get_instance_id():
			#area.receive_value(result)
			print(dime_health)
			pass
func get_value():
	return dime_health

func receive_value(value):
	print("Shot health: ", dime_health, " New health: ", value)
