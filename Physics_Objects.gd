extends RigidBody2D

func _ready():
	var shader_material = load("res://Physics_Objects_Shader.gdshader")
	material = ShaderMaterial.new()
	material.shader = shader_material
