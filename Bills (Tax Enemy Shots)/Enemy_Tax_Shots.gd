# This script fires a bill projectile from its associate tax enemy. 
# The size and fire rate change depending on the type of shot. 
extends Node2D

var bullet_scene: PackedScene
var shoot_timer: Timer
var sprite: Sprite2D

func _ready():
		var fire_rate = 0.0
		match name:
				"Sales_Tax_Shot":
						bullet_scene = preload("res://Bills (Tax Enemy Shots)/sales_tax_projectile.tscn")
						sprite = get_node("../Sales_Tax_Sprite")
						fire_rate = 0.8
				"Property_Tax_Shot":
						bullet_scene = preload("res://Bills (Tax Enemy Shots)/proprety_tax_projectile.tscn")
						sprite = get_node("../Property_Tax_Sprite")
						fire_rate = 1.5
				"Income_Tax_Shot":
						bullet_scene = preload("res://Bills (Tax Enemy Shots)/income_tax_projectile.tscn")
						sprite = get_node("../Income_Tax_Sprite")
						fire_rate = 3.0
				"Golden_Tax_Shot":
						bullet_scene = preload("res://Bills (Tax Enemy Shots)/golden_tax_projectile.tscn")
						sprite = get_node("../Golden_Tax_Sprite")
						fire_rate = 5.0


		# Fire rate timer
		shoot_timer = Timer.new()
		shoot_timer.wait_time = fire_rate
		shoot_timer.one_shot = false
		shoot_timer.timeout.connect(_on_shoot_timer_timeout)
		add_child(shoot_timer)
		shoot_timer.start()

func _on_shoot_timer_timeout():
		if not bullet_scene or not sprite or not get_tree() or not get_tree().current_scene:
				return  # Exit if any essential component is missing
		
		# Calculate distance to player
		var distance_to_player = sprite.global_position.distance_to(Global_Variables.player_position)
		
		# Only shoot if within 1000 units
		if distance_to_player <= 1000:
				var bullet = bullet_scene.instantiate()
				var spawn_position = sprite.global_position
				var sprite_half_height = sprite.texture.get_height() * sprite.scale.y / 2
				bullet.global_position = spawn_position + Vector2(0, sprite_half_height)
				
				# Calculate direction to player using Global_Variables.player_position
				var direction = (Global_Variables.player_position - bullet.global_position).normalized()
				bullet.rotation = direction.angle()
				
				get_tree().current_scene.add_child(bullet)
