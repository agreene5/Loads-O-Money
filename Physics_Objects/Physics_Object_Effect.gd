extends Area2D

var physics_position

func _ready():
	area_entered.connect(_on_area_entered)

func _on_area_entered(area):
	physics_position = area.get_parent().position
	Global_Variables.collision_animation(physics_position)
