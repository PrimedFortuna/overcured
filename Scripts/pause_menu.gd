extends Control

func resume():
	visible = false
	get_tree().paused = false
	$AnimationPlayer.play_backwards("blur")

func restart():
	get_tree().paused = false
	$AnimationPlayer.stop()  # Stop the animation immediately
	$AnimationPlayer.seek(0, true)  # Reset animation to the first frame
	get_tree().reload_current_scene()

func pause():
	visible = true  
	get_tree().paused = true
	$AnimationPlayer.play("blur")

	
func testEsc():
	if Input.is_action_just_pressed("esc") and !get_tree().paused:
		pause()
	elif Input.is_action_just_pressed("esc") and get_tree().paused:
		resume()


func _on_resume_pressed() -> void:
	resume()


func _on_restart_pressed() -> void:
	restart()


func _on_quit_pressed() -> void:
	get_tree().paused = false
	var main_menu_scene = load("res://Scenes/MainMenu.tscn")
	get_tree().change_scene_to_packed(main_menu_scene)
	
	
	
func _process(delta):
	testEsc()
