extends Node2D

var max_items: int = 6  
var pickup_items: Array = []  

@onready var grid_container: GridContainer = $GridContainer  

func add_item_to_table(item: Node):
	if pickup_items.size() < max_items:
		if item.get_parent():
			item.get_parent().remove_child(item)  

		pickup_items.append(item)  
		grid_container.add_child(item)  

		item.visible = true  
		item.scale = Vector2(1, 1)  
		item.position = Vector2.ZERO  

		update_item_positions()  
		print("Item added to table:", item.name)
	else:
		print("Table is full, can't add more items.")

func remove_item_from_table() -> Node:
	if pickup_items.size() > 0:
		var last_item = pickup_items.pop_back()  
		grid_container.remove_child(last_item)  
		update_item_positions()  
		last_item.visible = true  
		print("Picked up from table:", last_item.name)
		return last_item
	else:
		print("Table is empty.")
		return null

func update_item_positions():
	var cols = 3
	var rows = 2
	var container_size = grid_container.get_rect().size  # Get actual size
	var padding = 8  # Space between items
	
	# Determine item size dynamically based on available space
	var item_size_x = (container_size.x - (cols - 1) * padding) / cols
	var item_size_y = (container_size.y - (rows - 1) * padding) / rows
	var item_size = Vector2(item_size_x, item_size_y)

	var start_x = (container_size.x - (cols * item_size.x + (cols - 1) * padding)) / 2
	var start_y = (container_size.y - (rows * item_size.y + (rows - 1) * padding)) / 2

	for i in range(pickup_items.size()):
		var col = i % cols
		var row = i / cols
		pickup_items[i].position = Vector2(
			start_x + col * (item_size.x + padding),
			start_y + row * (item_size.y + padding)
		)
