# Pigeon Movement
extends AnimatedSprite2D

var current_target: Vector2
var start_position: Vector2
var control_point: Vector2
var t: float = 0.0
var movement_speed: float = 0.08  # Adjust this to control movement speed
var min_arc_size: float = 500.0  # Minimum size of the arc
var max_arc_size: float = 1500.0 # Maximum size of the arc

# Boundaries
var min_x: float = -3840.0
var max_x: float = 3360.0
var min_y: float = -4320.0
var max_y: float = 4800.0

func _ready():
		play()
		start_position = position
		set_new_target()

func _process(delta):
		# Move along the quadratic Bezier curve
		t += delta * movement_speed
		
		if t >= 1.0:
				# When reaching the target, set up a new curve
				start_position = position
				set_new_target()
				t = 0.0
		
		# Calculate new position using quadratic Bezier curve
		var new_position = quadratic_bezier(start_position, control_point, current_target, t)
		
		# Calculate movement direction for rotation
		var direction = (new_position - position).normalized()
		rotation = direction.angle() + PI/2  # Add PI/2 to face the movement direction
		
		# Update position
		position = new_position

func set_new_target():
		# Generate random target point within boundaries
		current_target = Vector2(
				randf_range(min_x, max_x),
				randf_range(min_y, max_y)
		)
		
		# Calculate direction vector from start to target
		var direction = current_target - start_position
		
		# Generate a control point for the arc
		# The control point will be perpendicular to the direction vector
		var perpendicular = Vector2(-direction.y, direction.x).normalized()
		var arc_size = randf_range(min_arc_size, max_arc_size)
		
		# Randomly choose left or right side for the arc
		if randf() > 0.5:
				perpendicular = -perpendicular
		
		# Set the control point
		control_point = start_position + direction * 0.5 + perpendicular * arc_size

func quadratic_bezier(p0: Vector2, p1: Vector2, p2: Vector2, t: float) -> Vector2:
		# Quadratic Bezier curve calculation
		var q0 = p0.lerp(p1, t)
		var q1 = p1.lerp(p2, t)
		return q0.lerp(q1, t)
