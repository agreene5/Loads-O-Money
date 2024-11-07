extends HBoxContainer

@export var font_size: int = 23
@export var exp_font_size: int = 23
@export var exp_stretch_scale: float = 5.5  # New export for stretching exp numbers
@export var font_path: String = "res://Finished_Assets/Comic_Sans_MS_FONT.ttf"

var job_levels = [
	{"name": "Fast Food", "exp": 2},
	{"name": "Food Manager", "exp": 20},
	{"name": "Operations Manager", "exp": 200},
	{"name": "CEO", "exp": 1000},
	{"name": "Tech CEO", "exp": 5000},
]

var exp_label: Label
var next_label: Label
var job_label: Label

func _ready() -> void:
	exp_label = Label.new()
	next_label = Label.new()
	job_label = Label.new()
	
	add_child(exp_label)
	add_child(next_label)
	add_child(job_label)
	
	update_font_size()

func _process(delta: float) -> void:
	var current_exp = Global_Variables.player_exp
	var current_level = get_current_level(current_exp)
	var next_level = get_next_level(current_exp)
	
	var next_job_name = next_level["name"] if next_level else "Max Level"
	
	exp_label.text = str(int(current_exp)) + "\n" + str(next_level["exp"] if next_level else current_level["exp"])
	
	next_label.text = "   Next:"
	
	job_label.text = format_job_name(next_job_name)

func get_current_level(exp: float) -> Dictionary:
	for i in range(job_levels.size() - 1, -1, -1):
		if exp >= job_levels[i]["exp"]:
			return job_levels[i]
	return job_levels[0]

func get_next_level(exp: float) -> Dictionary:
	for level in job_levels:
		if exp < level["exp"]:
			return level
	return {}

func format_job_name(job_name: String) -> String:
	var words = job_name.split(" ")
	if words.size() == 1:
		return job_name
	elif words.size() == 2:
		return words[0] + "\n" + words[1]
	else:
		return words[0] + "\n" + " ".join(words.slice(1))

func update_font_size() -> void:
	var font = load(font_path)
	if font is FontFile:
		var font_variation = FontVariation.new()
		font_variation.set_base_font(font)
		font_variation.set_spacing(TextServer.SPACING_TOP, 0)
		font_variation.set_spacing(TextServer.SPACING_BOTTOM, 0)
		
		for label in [next_label, job_label]:
			label.add_theme_font_size_override("font_size", font_size)
			label.add_theme_font_override("font", font_variation)
			label.add_theme_color_override("font_color", Color.BLACK)
			label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		
		# Setup for exp_label to be bold and stretched
		var bold_font_variation = font_variation.duplicate()
		bold_font_variation.set_variation_embolden(1.0)  # This makes the font bold
		
		exp_label.add_theme_font_size_override("font_size", exp_font_size)
		exp_label.add_theme_font_override("font", bold_font_variation)
		exp_label.add_theme_color_override("font_color", Color.BLACK)
		exp_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		exp_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		exp_label.scale.x = exp_stretch_scale  # Stretch horizontally
	else:
		print("Failed to load font")
