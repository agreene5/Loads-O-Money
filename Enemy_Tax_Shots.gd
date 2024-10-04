# This script fires a bill projectile from its associate tax enemy. 
# The size and fire rate change depending on the type of shot. 
extends Node2D

var bullet_scene: PackedScene
var shoot_timer: Timer
var sprite: Sprite2D
var shot_health: int

func _ready():
	var fire_rate = 0.0
	match name:
		"Sales_Tax_Shot":
			bullet_scene = preload("res://sales_tax_projectile.tscn")
			sprite = get_node("../Sales_Tax_Sprite")
			fire_rate = 0.8
		"Property_Tax_Shot":
			bullet_scene = preload("res://proprety_tax_projectile.tscn")
			sprite = get_node("../Property_Tax_Sprite")
			fire_rate = 1.5
		"Income_Tax_Shot":
			bullet_scene = preload("res://income_tax_projectile.tscn")
			sprite = get_node("../Income_Tax_Sprite")
			fire_rate = 3.0

	# Fire rate timer
	shoot_timer = Timer.new()
	shoot_timer.wait_time = fire_rate
	shoot_timer.one_shot = false
	shoot_timer.timeout.connect(_on_shoot_timer_timeout)
	add_child(shoot_timer)
	shoot_timer.start()

func _on_shoot_timer_timeout():
	if bullet_scene and sprite:
		var bullet = bullet_scene.instantiate()
		# Spawning shot at center of sprite
		var spawn_position = sprite.global_position
		var sprite_half_height = sprite.texture.get_height() * sprite.scale.y / 2
		bullet.global_position = spawn_position + Vector2(0, sprite_half_height)
		get_tree().current_scene.add_child(bullet)
