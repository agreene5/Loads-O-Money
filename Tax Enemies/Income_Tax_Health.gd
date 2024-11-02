#Script for income tax enemy's body
extends Area2D

@export var income_tax_health = Global_Variables.income_tax_health
@export var income_scale = 2.5

var tax_hit_sfx = preload("res://Finished_Assets/SFX_Assets/FasterTaxPaper.mp3")

var tax_position

var income_tax_exp = Global_Variables.income_tax_exp

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area_entered.connect(_on_area_entered)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func get_value():
	return income_tax_health

func receive_value(value):
	print("ENEMY  health: ", income_tax_health, " New health: ", income_tax_health+value)

func despawn():

	Global_Variables.player_exp += income_tax_exp
	print(Global_Variables.player_exp)

	get_parent().queue_free()

func _on_area_entered(area):
	if area.has_method("get_value"):
		var result = Global_Variables.calculate_difference(income_tax_health, area.get_value())
		#Play hit sfx 
		$AudioStreamPlayer.stream = tax_hit_sfx
		$AudioStreamPlayer.volume_db = -4
		$AudioStreamPlayer.play()
		
		if self.get_instance_id() < area.get_instance_id():
			area.receive_value(result)
			receive_value(-result)
			income_tax_health = income_tax_health - result
			if(income_tax_health <= 0):
				print("Income tax died")
				tax_position = get_parent().position
				Global_Variables.explosion_tax_animation(tax_position, income_scale)
				despawn()
