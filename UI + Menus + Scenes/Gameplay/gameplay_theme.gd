
extends AudioStreamPlayer  # or whatever node type it is

func _ready():
	Global_Variables.connect("mute_gameplay_theme", Callable(self, "_on_mute_gameplay_theme"))

func _on_mute_gameplay_theme(mute: bool):
	if mute:
		self.volume_db = -80  # or use stop() if you prefer
	else:
		self.volume_db = 0  # or use play() if you stopped it
