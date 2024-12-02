extends Node2D

func _ready():
		add_effects_to_all_buses()
		
func spawn_jumpscare():
	$Jumpscare_Spawner.spawn_jumpscare()
	
func fade_out():
	$Jumpscare_Spawner/AnimationPlayer.play("fade_out")

func add_effects_to_all_buses():
	var bus_count = AudioServer.bus_count
	
	# Loop through all audio buses
	for bus_idx in range(bus_count):
		var bus_name = AudioServer.get_bus_name(bus_idx)
		
		# Skip the Music bus
		if bus_name != "Music":
			# Create and add echo effect
			var echo_effect = AudioEffectDelay.new()
			echo_effect.tap1_delay_ms = 500
			echo_effect.tap1_level_db = -10
			echo_effect.tap2_delay_ms = 1000
			echo_effect.tap2_level_db = -20
			AudioServer.add_bus_effect(bus_idx, echo_effect)
			
			# Create and add reverb effect
			var reverb_effect = AudioEffectReverb.new()
			reverb_effect.room_size = 0.6
			reverb_effect.damping = 0.5
			reverb_effect.spread = 0.5
			reverb_effect.wet = 0.3
			reverb_effect.dry = 0.7
			AudioServer.add_bus_effect(bus_idx, reverb_effect)

func remove_all_audio_effects():
	var bus_count = AudioServer.bus_count
	
	# Loop through all audio buses
	for bus_idx in range(bus_count):
		var bus_name = AudioServer.get_bus_name(bus_idx)
		
		# Skip the Music bus
		if bus_name != "Music":
			# Get the number of effects on this bus
			var effect_count = AudioServer.get_bus_effect_count(bus_idx)
			
			# Remove all effects (loop backwards to avoid index issues)
			for effect_idx in range(effect_count - 1, -1, -1):
				AudioServer.remove_bus_effect(bus_idx, effect_idx)
				
