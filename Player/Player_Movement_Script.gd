extends Node2D

# Add Player/Main Character movement script here
var move_speed = 200
var velocity = Vector2.ZERO

func _process(delta):
	velocity = Vector2.ZERO

	if Input.is_action_pressed("up"):
		velocity.y -= 1
	if Input.is_action_pressed("down"):
		velocity.y += 1
	if Input.is_action_pressed("left"):
		velocity.x -= 1
	if Input.is_action_pressed("right"):
		velocity.x += 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * move_speed

	# Update the position of the parent Player node
	get_parent().position += velocity * delta
