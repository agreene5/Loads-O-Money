#Script for property tax enemy's body
extends Area2D

@export var property_tax_health = Global_Variables.property_tax_health
@export var property_scale = 1.5

var tax_hit_sfx = preload("res://Finished_Assets/SFX_Assets/FasterTaxPaper.mp3")

var tax_position
var physics_position

var property_tax_exp = Global_Variables.property_tax_exp

@onready var sprite = %Property_Tax_Sprite

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area_entered.connect(_on_area_entered)
	update_sprite()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func get_value():
	return property_tax_health

func receive_value(value):
	print("ENEMY  health: ", property_tax_health, " New health: ", property_tax_health+value)
	update_sprite()

func despawn():
	Global_Variables.player_exp += property_tax_exp
	Global_Variables.exp_label(property_tax_exp)
	print(Global_Variables.player_exp)
	get_parent().queue_free()

func _on_area_entered(area):
	if area.has_method("get_value"):
		physics_position = area.get_parent().position
		Global_Variables.collision_animation(physics_position)
		var result = Global_Variables.calculate_difference(property_tax_health, area.get_value())
		#Play hit sfx 
		$AudioStreamPlayer.stream = tax_hit_sfx
		$AudioStreamPlayer.volume_db = -4
		$AudioStreamPlayer.play()
		
		if self.get_instance_id() < area.get_instance_id():
			area.receive_value(result)
			receive_value(-result)
			property_tax_health = property_tax_health - result
			update_sprite()
			if(property_tax_health <= 0):
				print("Property tax died")
				tax_position = get_parent().position
				Global_Variables.explosion_tax_animation(tax_position, property_scale)
				despawn()

func update_sprite():
	var health_percentage = (property_tax_health / Global_Variables.property_tax_health) * 100
	
	if health_percentage >= 70:
		sprite.texture = load("res://Finished_Assets/Tax_Enemy_Assets/Property_Tax_High_Health.png")
	elif health_percentage >= 40:
		sprite.texture = load("res://Finished_Assets/Tax_Enemy_Assets/Property_Tax_Med_Health.png")
	else:
		sprite.texture = load("res://Finished_Assets/Tax_Enemy_Assets/Property_Tax_Low_Health.png")
