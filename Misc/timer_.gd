extends Control

var timer_label: Label
var timer: Timer

var elapsed_seconds = 0
var elapsed_milliseconds = 0

func _ready():
	# Find the Label node
	timer_label = get_node("Label") as Label
	if timer_label == null:
		push_error("Label node not found. Make sure you have a Label node named 'Label' as a direct child of this node.")
		return
	
	# Set up the Label
	timer_label.text = "0.00"
	timer_label.set_anchors_preset(Control.PRESET_TOP_LEFT)
	timer_label.position = Vector2(10, 10)  # 10 pixels from top and left edges
	
	# Set up the font
	var font = load("res://Finished_Assets/UI_Assets/Comic_Sans_MS_FONT.ttf")
	if font:
		var font_variation = FontVariation.new()
		font_variation.set_base_font(font)
		timer_label.add_theme_font_override("font", font_variation)
		timer_label.add_theme_font_size_override("font_size", 96)  # Increased font size (2x bigger)
		timer_label.add_theme_color_override("font_color", Color.BLACK)
		timer_label.add_theme_constant_override("outline_size", 4)
		timer_label.add_theme_color_override("font_outline_color", Color.WHITE)
	else:
		push_error("Font file not found. Check the path.")
	
	# Set up the Timer
	timer = Timer.new()
	add_child(timer)
	timer.timeout.connect(_on_Timer_timeout)
	timer.set_wait_time(1.0 / 60.0)  # Update 60 times per second
	timer.set_one_shot(false)
	timer.start()

func _on_Timer_timeout():
	elapsed_milliseconds += 1
	if elapsed_milliseconds >= 60:
		elapsed_milliseconds = 0
		elapsed_seconds += 1
	update_timer_label()

func update_timer_label():
	if timer_label == null:
		push_error("Cannot update timer label: Label node not found")
		return
	
	timer_label.text = "%d.%02d" % [elapsed_seconds, elapsed_milliseconds]

func start_timer():
	elapsed_seconds = 0
	elapsed_milliseconds = 0
	timer.start()

func stop_timer():
	timer.stop()

func reset_timer():
	elapsed_seconds = 0
	elapsed_milliseconds = 0
	update_timer_label()
