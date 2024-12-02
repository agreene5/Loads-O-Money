extends CanvasLayer

var pause_menu_instance = null # placeholder so Godot doesn't get angry

func upgrade_menu():
		# Create tween that processes even when paused
	var tween = create_tween().set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	
	# Fade out Gameplay theme
	tween.parallel().tween_property(%Gameplay_Theme, "volume_db", -30.0, 2.0)
	# Fade in Pause theme
	tween.parallel().tween_property(%Upgrade_Theme, "volume_db", 0.0, 1.0)
	
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
