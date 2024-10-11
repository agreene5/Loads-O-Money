# This script determines enemy movement, they move towards the player and aim to keep a 200
# unit distance, but they're rigid bodies so it's not 100% clean for them to do so

extends RigidBody2D

@export var Speed: float = 100
@export var Stop_Distance: float = 200
@export var Upright_Force: float = 5.0  # Force to rotate towards upright position
var Player_Pos: Vector2 = Vector2()
var Distance_To_Player: float

# Called when the node enters the scene tree for the first time.
func _ready():
	# Set the gravity scale to 0 to prevent the body from falling
	gravity_scale = 0
	# Assign the shader material
	var shader_material = load("res://Shaders/Player_Enemy_Shader.gdshader")
	material = ShaderMaterial.new()
	material.shader = shader_material

# Called every physics frame. 'delta' is the elapsed time since the previous frame.
func _integrate_forces(state):
	Player_Pos = Global_Variables.player_position # gets reference to player position
	Distance_To_Player = global_position.distance_to(Player_Pos)
	
	var force = Vector2.ZERO
	
	if Distance_To_Player > Stop_Distance: # keeps enemies certain distance from player
		var direction = (Player_Pos - global_position).normalized()
		force = direction * Speed
	
	# Apply the force to the RigidBody2D
	apply_central_force(force)
	
	var current_rotation = state.transform.get_rotation()
	var torque = sin(-current_rotation) * Upright_Force
	apply_torque(torque)
