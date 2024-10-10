extends Area2D

@export var dime_health = 8

func despawn():
	if dime_health <= 0:
		print("Despawning dime")
		queue_free()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area_entered.connect(_on_area_entered)


func _on_area_entered(area):
	if area.has_method("receive_value"):
		var result = Global_Variables.calculate_difference(dime_health, area.get_value())
		if self.get_instance_id() < area.get_instance_id():
			area.receive_value(result)
			dime_health =dime_health- result
			despawn()


func get_value():
	return dime_health

func receive_value(value):
	print("DIME SHOT health: ", dime_health, " New health: ", (dime_health-value))
