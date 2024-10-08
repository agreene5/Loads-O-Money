extends Node

var Player_Ref: Node
var Speed: float = 100
var Stop_Distance: float = 0
var Player_Pos: Vector2
var Current_Pos: Vector2
var Distance_To_Player: float
var myself: Node

# Called when the node enters the scene tree for the first time.
func _ready():
	Player_Ref = preload("res://Player/player.tscn").instantiate()
	myself = get_parent()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	Player_Pos = Player_Ref.global_position
	Current_Pos = myself.global_position
	Distance_To_Player = Current_Pos.distance_to(Player_Pos)
	print_debug(Current_Pos)
	
	if Distance_To_Player > Stop_Distance:
		var direction = (Player_Pos - Current_Pos).normalized()
		myself.global_position += direction * Speed * delta
	pass
