extends CharacterBody2D

var move_speed = 200
var rotation_speed = 10.0  # Speed rotating towards cursor
var dash_speed = 800
var dash_duration = 0.2
var dash_cooldown = 0.5
var double_tap_time = 0.2

var is_dashing = false
var can_dash = true
var last_tap = {}
var dash_direction = Vector2.ZERO

func _ready():
		for action in ["up", "down", "left", "right"]:
				last_tap[action] = 0

func _physics_process(delta):
		var current_time = Time.get_ticks_msec() / 1000.0
		
		if not is_dashing:
				velocity = Vector2.ZERO
				if Input.is_action_pressed("up"):
						velocity.y -= 1
						check_double_tap("up", current_time)
				if Input.is_action_pressed("down"):
						velocity.y += 1
						check_double_tap("down", current_time)
				if Input.is_action_pressed("left"):
						velocity.x -= 1
						check_double_tap("left", current_time)
				if Input.is_action_pressed("right"):
						velocity.x += 1
						check_double_tap("right", current_time)

				if velocity.length() > 0:
						velocity = velocity.normalized() * move_speed
		else:
				velocity = dash_direction * dash_speed

		move_and_slide()

		# Rotating towards cursor
		var target_angle = (get_global_mouse_position() - global_position).angle()
		rotation = lerp_angle(rotation, target_angle, rotation_speed * delta)

func check_double_tap(action, current_time):
		if Input.is_action_just_pressed(action):
				if current_time - last_tap[action] < double_tap_time:
						initiate_dash(action)
				last_tap[action] = current_time

func initiate_dash(action):
		if can_dash:
				is_dashing = true
				can_dash = false
				dash_direction = Vector2.ZERO
				match action:
						"up": dash_direction.y = -1
						"down": dash_direction.y = 1
						"left": dash_direction.x = -1
						"right": dash_direction.x = 1
				dash_direction = dash_direction.normalized()
				get_tree().create_timer(dash_duration).connect("timeout", Callable(self, "end_dash"))
				get_tree().create_timer(dash_cooldown).connect("timeout", Callable(self, "reset_dash"))

func end_dash():
		is_dashing = false

func reset_dash():
		can_dash = true
