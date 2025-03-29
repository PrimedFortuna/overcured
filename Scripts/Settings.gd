extends Control

func _ready():
	$BackButton.connect("pressed", _on_back_pressed)
	$VSyncButton.connect("pressed", _on_vsync_pressed)
	$FullscreenButton.connect("pressed", _on_fullscreen_pressed)
	$SkinButton.connect("pressed",_on_skin_pressed)

func _on_back_pressed():
	get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")
	
func _on_skin_pressed():
	get_tree().change_scene_to_file("res://Scenes/SkinSelection.tscn")

func _on_vsync_pressed():
	DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED if DisplayServer.window_get_vsync_mode() == DisplayServer.VSYNC_DISABLED else DisplayServer.VSYNC_DISABLED)

func _on_fullscreen_pressed():
	var is_fullscreen = DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED if is_fullscreen else DisplayServer.WINDOW_MODE_FULLSCREEN)
