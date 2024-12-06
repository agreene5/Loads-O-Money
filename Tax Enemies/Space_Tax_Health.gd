extends Area2D

@export var sales_tax_health = Global_Variables.sales_tax_health
@export var sales_scale = 0.8

var tax_hit_sfx = preload("res://Temp_Assets/Temp_SFX_Assets/LaserGunSFX.mp3")

var tax_position
var physics_position

var sales_tax_exp = Global_Variables.sales_tax_exp
var previous_health = 0
var despawn_timer = 0.0
const DESPAWN_TIME = 45.0

@onready var sprite = %Space_Tax_Sprite

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
		area_entered.connect(_on_area_entered)
		update_sprite()
		previous_health = sales_tax_health

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
		if previous_health == sales_tax_health:
				despawn_timer += delta
				if despawn_timer >= DESPAWN_TIME:
						# Start fade out
						var tween = create_tween()
						tween.tween_property(sprite, "modulate:a", 0.0, 1.0)
						tween.tween_callback(func(): get_parent().queue_free())
		else:
				# Reset timer if health changed
				despawn_timer = 0.0
				previous_health = sales_tax_health

func get_value():
		return sales_tax_health

func receive_value(value):
		print("ENEMY  health: ", sales_tax_health, " New health: ", sales_tax_health+value)
		update_sprite()

signal initiate_abduction
func space_despawn_event():
		Global_Variables.emit_signal("space_abduction_triggered")
		Global_Variables.exp_label("+???")
		print(Global_Variables.player_exp)
		get_parent().queue_free()

func _on_area_entered(area):
		if area.has_method("get_value"):
				physics_position = area.get_parent().position
				Global_Variables.collision_animation(physics_position)
				var result = Global_Variables.calculate_difference(sales_tax_health, area.get_value())

				#Play hit sfx 
				$AudioStreamPlayer.stream = tax_hit_sfx
				$AudioStreamPlayer.volume_db = -10
				$AudioStreamPlayer.play()
				
				if self.get_instance_id() < area.get_instance_id():
						area.receive_value(result)
						receive_value(-result)

						sales_tax_health = sales_tax_health - result
						update_sprite()
						if(sales_tax_health <= 0):
								print("Sales tax died")
								tax_position = get_parent().position
								Global_Variables.explosion_tax_animation(tax_position, sales_scale)
								space_despawn_event()

func update_sprite():
		var health_percentage = (sales_tax_health / (Global_Variables.sales_tax_health)) * 100
		
		if health_percentage >= 50:
				sprite.texture = load("res://Finished_Assets/Tax_Enemy_Assets/Space_Tax_High_Health.png")
		else:
				sprite.texture = load("res://Finished_Assets/Tax_Enemy_Assets/Space_Tax_Low_Health.png")
