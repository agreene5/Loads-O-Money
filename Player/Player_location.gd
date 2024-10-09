extends Node

var myself: Node
var current_pos: Vector2
signal position_changed(new_position: Vector2)

# Called when the node enters the scene tree for the first time.
func _ready():
	myself = get_parent()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	current_pos = myself.global_position #gets position of player node
	Global_Variables.player_position = current_pos #sets the variable as said position
	
	pass
