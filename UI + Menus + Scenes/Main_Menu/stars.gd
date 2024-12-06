extends Node2D

func _ready():
		if Global_Variables.star_1:
				var frames = SpriteFrames.new()
				frames.add_animation("default")
				frames.set_animation_loop("default", true)
				frames.add_frame("default", load("res://Finished_Assets/UI_Assets/UI_Star_Assets/Star1_1.png"))
				frames.add_frame("default", load("res://Finished_Assets/UI_Assets/UI_Star_Assets/Star1_2.png"))
				frames.add_frame("default", load("res://Finished_Assets/UI_Assets/UI_Star_Assets/Star1_3.png"))
				$Star_1.sprite_frames = frames
				
		if Global_Variables.star_2:
				var frames = SpriteFrames.new()
				frames.add_animation("default")
				frames.set_animation_loop("default", true)
				frames.add_frame("default", load("res://Finished_Assets/UI_Assets/UI_Star_Assets/Star2_1.png"))
				frames.add_frame("default", load("res://Finished_Assets/UI_Assets/UI_Star_Assets/Star2_2.png"))
				frames.add_frame("default", load("res://Finished_Assets/UI_Assets/UI_Star_Assets/Star2_3.png"))
				$Star_2.sprite_frames = frames
				
		if Global_Variables.star_3:
				var frames = SpriteFrames.new()
				frames.add_animation("default")
				frames.set_animation_loop("default", true)
				frames.add_frame("default", load("res://Finished_Assets/UI_Assets/UI_Star_Assets/Star3_1.png"))
				frames.add_frame("default", load("res://Finished_Assets/UI_Assets/UI_Star_Assets/Star3_2.png"))
				frames.add_frame("default", load("res://Finished_Assets/UI_Assets/UI_Star_Assets/Star3_3.png"))
				$Star_3.sprite_frames = frames
				
		$Star_1.play()
		$Star_2.play()
		$Star_3.play()  # Fixed the typo in the original code where Star_2 was called twice
