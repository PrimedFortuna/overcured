extends Node2D

var max_items: int = 6  
var pickup_items: Array = []  

@onready var grid_container: GridContainer = $GridContainer  

# Adds item to the table
func add_item_to_table(item: Node):
	if pickup_items.size() < max_items:
		if item.get_parent():
			item.get_parent().remove_child(item)  # Remove from previous parent

		pickup_items.append(item)  # Add to the table items list
		grid_container.add_child(item)  # Add to the GridContainer

		item.visible = true  # Make the item visible
		item.scale = Vector2(1, 1)  # Reset scale
		item.position = Vector2.ZERO  # Set to initial position

		update_item_positions()  # Update the layout of the items
		print("Item added to table:", item.name)
	else:
		print("Table is full, can't add more items.")

# Removes the last item added to the table (FILO)
func remove_item_from_table() -> Node:
	if pickup_items.size() > 0:
		var last_item = pickup_items.pop_back()  # Remove last item
		grid_container.remove_child(last_item)  # Remove from grid container
		update_item_positions()  # Update the remaining item positions
		print("Picked up from table:", last_item.name)
		return last_item
	else:
		print("Table is empty.")
		return null

# Updates the positions of items in the table
func update_item_positions():
	var table_width = grid_container.size.x 
	var table_height = grid_container.size.y
	var cols = 3
	var rows = 2
	var cell_width = table_width / cols
	var cell_height = table_height / rows

	for i in range(pickup_items.size()):
		var col = i % cols
		var row = i / cols
		var item_pos = Vector2(col * cell_width + cell_width / 2, row * cell_height + cell_height / 2)
		pickup_items[i].position = item_pos
