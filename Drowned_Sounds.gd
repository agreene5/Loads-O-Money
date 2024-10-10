extends AudioStreamPlayer2D

func _ready():
	await get_tree().create_timer(0.1).timeout
	# Load the audio file
	var audio = load("res://Finished_Assets/Voice_Line_Assets/Death_Voice_Lines_1.wav")
	
	# Set the stream and play the first audio
	self.stream = audio
	self.play()
	
	# Create a timer for the delay
	var timer = get_tree().create_timer(1.0)
	
	# Connect the timer's timeout signal to play the second audio
	timer.timeout.connect(play_second_audio)

func play_second_audio():
	# Load and play the second audio file
	var audio = load("res://Finished_Assets/Voice_Line_Assets/Death_Voice_Lines_1.wav")
	self.stream = audio
	self.play()
