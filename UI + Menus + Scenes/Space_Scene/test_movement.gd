extends StaticBody2D

var speed = 200  # Speed in units per second

func _process(delta):
	# Move the body to the right
	position.x += speed * delta
