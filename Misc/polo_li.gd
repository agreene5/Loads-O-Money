extends RigidBody2D

var target_rotation: float = 0.0
var current_rotation: float = 0.0
var rotation_speed: float = 2.0  # Adjust this to control rotation smoothness
var is_rotating: bool = false

func _ready():
	await get_tree().create_timer(0.01).timeout
	$Polo_Detector/PoloRob_Text.visible = false
	start_random_rotation()

func start_random_rotation():
	var random_delay = randf_range(0.5, 2.0)
	if get_tree():
		var timer = get_tree().create_timer(random_delay)
		await timer.timeout
		# Set new target rotation
		target_rotation = deg_to_rad(randf_range(-3.0, 3.0))
		is_rotating = true
		# Start the next random rotation
		start_random_rotation()

func _physics_process(delta):
	# Handle smooth rotation
	if is_rotating:
		current_rotation = rotation
		# Smoothly interpolate to target rotation
		current_rotation = lerp_angle(current_rotation, target_rotation, rotation_speed * delta)
		rotation = current_rotation
		
		# Check if we're close enough to target rotation
		if abs(current_rotation - target_rotation) < 0.01:
			is_rotating = false

	# Original input handling
	if Input.is_action_just_pressed("Rob_Polo") and Global_Variables.polo_rob_range:
		queue_free()
		print("You've Robbed Polo!!!")

func _on_polo_detector_area_entered(area):
	if area.name == "Todd_Body_Signaler":
		Global_Variables.polo_rob_range = true
		$Polo_Detector/PoloRob_Text.visible = true
		$Polo_Detector/PoloRob_Text.play()
		print("inside polo detector")

func _on_polo_detector_area_exited(area):
	if area.name == "Todd_Body_Signaler":
		Global_Variables.polo_rob_range = false
		$Polo_Detector/PoloRob_Text.visible = false
