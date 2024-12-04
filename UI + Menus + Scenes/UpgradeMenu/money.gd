extends Label

func _process(_delta):
		text = "Finances: $%.2f" % Global_Variables.money
