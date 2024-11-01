#Script for property tax enemy's body
extends Area2D

@export var my_value = 75.0
@export var property_scale = 1.5


var tax_hit_sfx = preload("res://Finished_Assets/SFX_Assets/FasterTaxPaper.mp3")

var tax_position

var property_tax_exp = Global_Variables.property_tax_exp

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area_entered.connect(_on_area_entered)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func get_value():
	return my_value

func receive_value(value):
	print("ENEMY  health: ", my_value, " New health: ", my_value+value)

func despawn():
	Global_Variables.player_exp += property_tax_exp
	print(Global_Variables.player_exp)
	get_parent().queue_free()

func _on_area_entered(area):
	if area.has_method("get_value"):
		var result = Global_Variables.calculate_difference(my_value, area.get_value())
		#Play hit sfx 
		$AudioStreamPlayer.stream = tax_hit_sfx
		$AudioStreamPlayer.volume_db = -4
		$AudioStreamPlayer.play()
		
		if self.get_instance_id() < area.get_instance_id():
			area.receive_value(result)
			receive_value(-result)
			my_value = my_value - result
			if(my_value <= 0):
				print("Property tax died")
				tax_position = get_parent().position
				Global_Variables.explosion_tax_animation(tax_position, property_scale)
				despawn()
