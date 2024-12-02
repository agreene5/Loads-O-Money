extends Node2D

var sprites = []
var original_modulate = {}
var is_flashing = false
const FLASH_INTERVAL = 1.77777777778
const FLASH_DURATION = 0.1

# Wave motion variables
var time = 0.0
const WAVE_SPEED = 0.5  # How fast the wave moves
const WAVE_AMPLITUDE_X = 0.5  # How far it moves horizontally
const WAVE_AMPLITUDE_Y = 0.5  # How far it moves vertically
var original_position = Vector2.ZERO

func _ready():
	# Store the original position
	original_position = position
	
	# Get specific sprites by name
	for i in range(1, 5):
		var sprite = get_node("BG_Space_" + str(i))
		if sprite:
			sprites.append(sprite)
			original_modulate[sprite] = sprite.modulate
	
	# Create and start the flash timer
	var timer = Timer.new()
	add_child(timer)
	timer.wait_time = FLASH_INTERVAL
	timer.connect("timeout", _on_flash_timer_timeout)
	timer.start()

func _process(delta):
	# Update wave motion
	time += delta
	
	# Calculate new position using sine waves
	var new_x = original_position.x + sin(time * WAVE_SPEED) * WAVE_AMPLITUDE_X
	var new_y = original_position.y + cos(time * WAVE_SPEED * 1.3) * WAVE_AMPLITUDE_Y  # 1.3 creates a slight phase difference
	
	# Apply new position
	position = Vector2(new_x, new_y)

func _on_flash_timer_timeout():
	flash_white()

func flash_white():
	if is_flashing:
		return
	
	is_flashing = true
	
	# Set all sprites to bright white
	for sprite in sprites:
		sprite.modulate = Color(2.0, 2.0, 2.0, 1.0)
	
	# Create timer for flash duration
	var duration_timer = Timer.new()
	add_child(duration_timer)
	duration_timer.wait_time = FLASH_DURATION
	duration_timer.one_shot = true
	duration_timer.connect("timeout", _on_flash_duration_timeout)
	duration_timer.start()

func _on_flash_duration_timeout():
	# Reset all sprites to their original colors
	for sprite in sprites:
		sprite.modulate = original_modulate[sprite]
	
	is_flashing = false
	
	# Clean up the duration timer
	get_child(-1).queue_free()
