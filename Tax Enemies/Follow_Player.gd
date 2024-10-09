extends Node

var Player_Ref: Node
var Speed: float = 100
var Stop_Distance: float = 200
var Player_Pos: Vector2 = Vector2()
var Current_Pos: Vector2
var Distance_To_Player: float
var myself: Node

# Called when the node enters the scene tree for the first time.
func _ready():
	
	myself = get_parent() #uses position of whole node, not of scipt
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	Player_Pos = Global_Variables.player_position #gets reference to player position
	Current_Pos = myself.global_position #gets position of node
	Distance_To_Player = Current_Pos.distance_to(Player_Pos)
	
	if Distance_To_Player > Stop_Distance: #keeps enemies certain distance from player
		var direction = (Player_Pos - Current_Pos).normalized()
		myself.global_position += direction * Speed * delta
	pass

