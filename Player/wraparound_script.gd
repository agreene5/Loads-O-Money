extends Node2D

@export var left_bound: float = -335.0
@export var right_bound: float = 1430.0  # Set this to your desired right boundary

@onready var player = get_parent()

# Adjust these values to match your player's size
const PLAYER_WIDTH = 50
const PLAYER_HEIGHT = 60

func _process(_delta):
		# Horizontal wraparound
		if player.global_position.x < left_bound - PLAYER_WIDTH/2:
				player.global_position.x = right_bound + PLAYER_WIDTH/2
		elif player.global_position.x > right_bound + PLAYER_WIDTH/2:
				player.global_position.x = left_bound - PLAYER_WIDTH/2
