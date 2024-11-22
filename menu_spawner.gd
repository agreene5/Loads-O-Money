extends CanvasLayer

var pause_menu_instance = null # placeholder so Godot doesn't get angry

func upgrade_menu():
	var upgrade_menu_scene = load("res://UI + Menus + Scenes/UpgradeMenu/upgrade_menu.tscn")
	var upgrade_menu_instance = upgrade_menu_scene.instantiate()
	add_child(upgrade_menu_instance)

func pause_menu():
	if Global_Variables.is_paused == false:
		get_tree().paused = true
		var pause_menu_scene = load("res://UI + Menus + Scenes/Pause_Menu/pause_menu.tscn")
		var pause_menu_instance = pause_menu_scene.instantiate()
		add_child(pause_menu_instance)
		await get_tree().create_timer(0.1).timeout # Tiny wait to prevent menu re-opening on every esc press
		Global_Variables.is_paused = true

func tax_evasion():
	get_tree().paused = true
	var pre_tax_evasion_scene = load("res://UI + Menus + Scenes/Tax_Evasion_Scene/pre_tax_evasion_congrats.tscn")
	var pre_tax_evasion_instance = pre_tax_evasion_scene.instantiate()
	add_child(pre_tax_evasion_instance)
