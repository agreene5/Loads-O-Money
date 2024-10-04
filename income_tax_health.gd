extends Area2D
var income_tax_health = 50

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	area_entered.connect(_on_area_entered)

func despawn():
	if income_tax_health <= 0:
		queue_free()
		
		

func _on_area_entered(area) -> void:
	Global_Variables.hit(area,income_tax_health)
	print("Test")
	
