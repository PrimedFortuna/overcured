extends Control

func _ready():
	$StartButton.connect("pressed", _on_start_pressed)
	$ExitButton.connect("pressed", _on_quit_pressed)
	$SettingsButton.connect("pressed", _on_settings_pressed)

func _on_start_pressed():
	get_tree().change_scene_to_file("res://GameScene.tscn")

func _on_quit_pressed():
	get_tree().quit()

func _on_settings_pressed():
	get_tree().change_scene_to_file("res://Settings.tscn")
