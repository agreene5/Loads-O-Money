extends Label

@export var font_size: int = 30
@export var font_path: String = "res://Finished_Assets/Comic_Sans_MS_FONT.ttf"

func _ready() -> void:
	update_font_size()

func _process(delta: float) -> void:
	text = "$%.2f" % Global_Variables.money

func update_font_size() -> void:
	var font = load(font_path)
	if font is FontFile:
		var font_variation = FontVariation.new()
		font_variation.set_base_font(font)
		font_variation.set_variation_embolden(0.0)
		font_variation.set_spacing(TextServer.SPACING_TOP, 0)
		font_variation.set_spacing(TextServer.SPACING_BOTTOM, 0)
		
		var new_font_size = font_size
		add_theme_font_size_override("font_size", new_font_size)
		add_theme_font_override("font", font_variation)
	else:
		print("Failed to load font")
