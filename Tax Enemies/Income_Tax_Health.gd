#Script for income tax enemy's body
extends Area2D

@export var income_tax_health = Global_Variables.income_tax_health
@export var income_scale = 2.5

var tax_hit_sfx = preload("res://Finished_Assets/SFX_Assets/FasterTaxPaper.mp3")

var tax_position
var physics_position

var income_tax_exp = Global_Variables.income_tax_exp

@onready var sprite = %Income_Tax_Sprite

var last_health_value = 0
var health_unchanged_timer = 0.0
const DESPAWN_TIME = 60.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area_entered.connect(_on_area_entered)
	update_sprite()

	last_health_value = income_tax_health  # (or whatever your health variable is named)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func get_value():
	return income_tax_health

func receive_value(value):
	print("ENEMY  health: ", income_tax_health, " New health: ", income_tax_health+value)
	update_sprite()

func despawn():
	Global_Variables.player_exp += income_tax_exp
	Global_Variables.exp_label(income_tax_exp)
	print(Global_Variables.player_exp)
	get_parent().queue_free()

func _on_area_entered(area):
	physics_position = area.get_parent().position
	Global_Variables.collision_animation(physics_position)
	if area.has_method("get_value"):
		var result = Global_Variables.calculate_difference(income_tax_health, area.get_value())
		#Play hit sfx 
		$AudioStreamPlayer.stream = tax_hit_sfx
		$AudioStreamPlayer.volume_db = -7
		$AudioStreamPlayer.play()
		
		if self.get_instance_id() < area.get_instance_id():
			area.receive_value(result)
			receive_value(-result)
			income_tax_health = income_tax_health - result
			update_sprite()
			if(income_tax_health <= 0):
				print("Income tax died")
				tax_position = get_parent().position
				Global_Variables.explosion_tax_animation(tax_position, income_scale)
				despawn()

func update_sprite():
	var health_percentage = (income_tax_health / Global_Variables.income_tax_health) * 100
	
	if health_percentage >= 70:
		sprite.texture = load("res://Finished_Assets/Tax_Enemy_Assets/Income_Tax_High_Health.png")
	elif health_percentage >= 40:
		sprite.texture = load("res://Finished_Assets/Tax_Enemy_Assets/Income_Tax_Med_Health.png")
	else:
		sprite.texture = load("res://Finished_Assets/Tax_Enemy_Assets/Income_Tax_Low_Health.png")

func _process(delta):
		if income_tax_health == last_health_value:  # (use your health variable name)
				health_unchanged_timer += delta
				if health_unchanged_timer >= DESPAWN_TIME:
						get_parent().queue_free()
		else:
				health_unchanged_timer = 0.0
				last_health_value = income_tax_health  # (use your health variable name)
