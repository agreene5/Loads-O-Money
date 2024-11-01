#Script for sales tax enemy's body
extends Area2D


@export var sales_tax_health = 50.0

@export var sales_scale = 1.0

var tax_hit_sfx = preload("res://Finished_Assets/SFX_Assets/FasterTaxPaper.mp3")

var tax_position

var sales_tax_exp = Global_Variables.sales_tax_exp


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area_entered.connect(_on_area_entered)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func get_value():
	return sales_tax_health

func receive_value(value):
	print("ENEMY  health: ", sales_tax_health, " New health: ", sales_tax_health+value)

func despawn():
	Global_Variables.player_exp += sales_tax_exp
	print(Global_Variables.player_exp)

	get_parent().queue_free()

func _on_area_entered(area):
	if area.has_method("get_value"):
		var result = Global_Variables.calculate_difference(sales_tax_health, area.get_value())

		#Play hit sfx 
		$AudioStreamPlayer.stream = tax_hit_sfx
		$AudioStreamPlayer.volume_db = -4
		$AudioStreamPlayer.play()
		
		if self.get_instance_id() < area.get_instance_id():
			area.receive_value(result)
			receive_value(-result)

			sales_tax_health = sales_tax_health - result
			if(sales_tax_health <= 0):

				print("Sales tax died")
				tax_position = get_parent().position
				Global_Variables.explosion_tax_animation(tax_position, sales_scale)
				despawn()
