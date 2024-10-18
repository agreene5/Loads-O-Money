extends Area2D
@export var my_value = 50

# Called when the node enters the scene tree for the first time.
func _ready():
	area_entered.connect(_on_area_entered)


# Called every frame. 'delta' is the elapsed time since the previous frame.


func despawn():
		queue_free()

func _on_area_entered(area):
	if area.has_method("get_value"):
		var result = Global_Variables.calculate_difference(my_value, area.get_value())
		#Play hit sfx 
		#Have tax enemy die and play explosion animation and sfx if health is less than or equal to 0
		if self.get_instance_id() < area.get_instance_id():
			area.receive_value(result)
			receive_value(-result)
			print(my_value)
			my_value = my_value - result
			if(my_value <= 0):
				print("Income tax died")
				despawn()
	
func get_value():
	return my_value

func receive_value(value):
	print("ENEMY  health: ", my_value, " New health: ", value)
