extends CharacterBody2D

var Speed: float = 100
var Stop_Distance: float = 200
var Player_Pos: Vector2 = Vector2()
var Distance_To_Player: float

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body if needed.

# Called every physics frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	Player_Pos = Global_Variables.player_position # gets reference to player position
	Distance_To_Player = global_position.distance_to(Player_Pos)
	
	if Distance_To_Player > Stop_Distance: # keeps enemies certain distance from player
		var direction = (Player_Pos - global_position).normalized()
		velocity = direction * Speed
	else:
		velocity = Vector2.ZERO
	
	move_and_slide()
