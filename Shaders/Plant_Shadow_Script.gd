extends Node2D

@export var shadow_offset: Vector2 = Vector2(20, 20)
@onready var sprite: Sprite2D = $Sprite
@onready var shadow: Sprite2D = $Shadow

func _ready():
	# Ensure the shadow uses the same texture as the main sprite
	shadow.texture = sprite.texture
	
	# Set the shadow's position
	update_shadow_position()

func _process(_delta):
	# Update shadow position every frame
	# (you might want to optimize this depending on your needs)
	update_shadow_position()

func update_shadow_position():
	shadow.position = shadow_offset
