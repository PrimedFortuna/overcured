extends Control

func _ready():
	$Button.connect("pressed", _on_back_pressed)
	
func _on_back_pressed():
	get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")


func _on_button_pressed() -> void:
	pass # Replace with function body.
