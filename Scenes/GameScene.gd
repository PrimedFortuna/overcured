extends Node2D

# Player and table references
@onready var player = $Player
@onready var table: Node2D = $Table
@onready var grid_container: GridContainer = $Table/GridContainer

# Table management
var max_items: int = 6  
var pickup_items: Array = []  

func _ready():
	# Check if the nodes are correctly assigned
	if table:
		print("Table node is correctly assigned.")
	else:
		print("Error: Table node is null. Make sure it's in the scene.")

	if grid_container:
		print("GridContainer node is correctly assigned.")
	else:
		print("Error: GridContainer node is null. Check the node path.")

# Handle player interaction (pickup and drop)
func _input(event):
	if event.is_action_pressed("ui_select"):
		var item = player.find_nearest_pickup_item()
		if item:
			player.interact(item)

# Add item to the table (called by the player script when an item is picked up)
func add_item_to_table(item: Node):
	if pickup_items.size() < max_items:  
		# Ensure the item is not already part of the table
		if item.get_parent():
			item.get_parent().remove_child(item)

		pickup_items.append(item)
		grid_container.add_child(item)  # Add item to the GridContainer
		print("Children in GridContainer:", grid_container.get_child_count())
		item.show()  # Make the item visible
		item.queue_redraw()  # Redraw if needed
		grid_container.visible = true
		update_item_positions()  
		print("Item added to table:", item.name)
	else:
		print("Table is full, can't add more items.")

# Remove item from the table (FILO)
func remove_item_from_table() -> Node:
	if pickup_items.size() > 0:
		var last_item = pickup_items.pop_back()  # FILO (remove last added item)
		
		# Remove the item from the grid container
		if last_item.get_parent():
			grid_container.remove_child(last_item)
		
		update_item_positions()  # Update positions of other items
		print("Picked up from table:", last_item.name)
		return last_item
	else:
		print("Table is empty.")
		return null

# Update item positions in the grid
func update_item_positions():
	var table_width = grid_container.size.x 
	var table_height = grid_container.size.y
	var cols = 3
	var rows = 2
	var cell_width = table_width / cols
	var cell_height = table_height / rows

	# Update positions for each item
	for i in range(pickup_items.size()):
		var col = i % cols
		var row = i / cols
		var item_pos = Vector2(col * cell_width + cell_width / 2, row * cell_height + cell_height / 2)
		pickup_items[i].position = item_pos  
		pickup_items[i].visible = true
