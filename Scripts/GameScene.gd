extends Node2D

@onready var player = $Player

func _input(event):
	if event.is_action_pressed("ui_select"):
		var item = player.find_nearest_pickup_item()
		player.interact(item)
