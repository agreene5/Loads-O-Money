extends Area2D

@export var income_bill_health = Global_Variables.income_tax_shot_health   # Set initial health for IncomeBill

func _ready():
	area_entered.connect(_on_area_entered)

func _on_area_entered(area):
	if area.has_method("get_value"):
		var damage = Global_Variables.calculate_collision(income_bill_health, area.get_value())
		
		if self.get_instance_id() < area.get_instance_id():
			area.receive_value(damage)
			apply_damage(damage)

func get_value():
	return income_bill_health
	
# Applies received damage, checks if bullet should despawn
func receive_value(value: float):
	apply_damage(value)

# Reduces health and despawns if health reaches zero
func apply_damage(damage: float):
	await get_tree().create_timer(0.1).timeout # Slight delay to allow for physical collision to occur
	income_bill_health -= damage
	print(income_bill_health, " my new income health")
	if income_bill_health <= 0:
		print("IncomeBullet despawning due to zero health.")
		get_parent().queue_free()
