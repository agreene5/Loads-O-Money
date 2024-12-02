#Script for Golden  tax enemy's body
extends Area2D

@export var golden_tax_health = Global_Variables.golden_tax_health
@export var golden_scale = 5.0

var tax_hit_sfx = preload("res://Finished_Assets/SFX_Assets/FasterTaxPaper.mp3")

var tax_position
var physics_position

var golden_tax_exp = Global_Variables.golden_tax_exp

@onready var sprite = %Golden_Tax_Sprite

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area_entered.connect(_on_area_entered)
	update_sprite()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func get_value():
	return golden_tax_health

func receive_value(value):
	print("ENEMY  health: ", golden_tax_health, " New health: ", golden_tax_health+value)
	update_sprite()

func despawn():
	Global_Variables.player_exp += golden_tax_exp
	Global_Variables.exp_label(golden_tax_exp)
	print(Global_Variables.player_exp)
	get_parent().queue_free()

func _on_area_entered(area):
	physics_position = area.get_parent().position
	Global_Variables.collision_animation(physics_position)
	if area.has_method("get_value"):
		var result = Global_Variables.calculate_difference(golden_tax_health, area.get_value())
		#Play hit sfx 
		$AudioStreamPlayer.stream = tax_hit_sfx
		$AudioStreamPlayer.volume_db = -3
		$AudioStreamPlayer.pitch_scale = 0.8  # Pitch down to 0.9 scale
		$AudioStreamPlayer.play()
		
		if self.get_instance_id() < area.get_instance_id():
			area.receive_value(result)
			receive_value(-result)
			golden_tax_health = golden_tax_health - result
			update_sprite()
			if (golden_tax_health <= 0):
				print("Golden tax died")
				var yipeee = preload("res://Temp_Assets/Temp_SFX_Assets/Yippee_SFX.mp3")
				$AudioStreamPlayer.stream = yipeee
				$AudioStreamPlayer.pitch_scale = 0.8  # Pitch down to 0.9 scale
				$AudioStreamPlayer.play()
				tax_position = get_parent().position
				Global_Variables.explosion_tax_animation(tax_position, golden_scale)
				despawn()

func update_sprite():
	var health_percentage = (golden_tax_health / Global_Variables.golden_tax_health) * 100
	
	if health_percentage >= 70:
		sprite.texture = load("res://Finished_Assets/Tax_Enemy_Assets/GoldenTax_High_Health.png")
	elif health_percentage >= 40:
		sprite.texture = load("res://Finished_Assets/Tax_Enemy_Assets/GoldenTax_Medium_Health.png")
	else:
		sprite.texture = load("res://Finished_Assets/Tax_Enemy_Assets/GoldenTax_Low_Health.png")
