extends Control

@onready var texture_rect = $TextureRect
@onready var audio_player = AudioStreamPlayer.new()

func _ready():
		get_tree().root.size_changed.connect(_on_viewport_size_changed)
		_on_viewport_size_changed()
		
		# Add and configure the AudioStreamPlayer
		add_child(audio_player)
		audio_player.stream = load("res://Finished_Assets/Voice_Line_Assets/Death_Voice_Lines_1.wav")
		audio_player.play()

func _on_viewport_size_changed():
		texture_rect.size = get_viewport_rect().size
