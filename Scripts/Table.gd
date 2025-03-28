extends Node2D

@export var max_items : int = 6  
var pickup_items : Array = []  

@onready var grid_container : GridContainer = $GridContainer  

func add_item_to_table(item: Node):
	if pickup_items.size() < max_items:  
		pickup_items.append(item)
		grid_container.add_child(item)  
		print("Item added to table:", item.name)
	else:
		print("Table is full, can't add more items.")

func remove_item_from_table(item: Node):
	if item in pickup_items:
		pickup_items.erase(item)
		grid_container.remove_child(item)  
		print("Item removed from table:", item.name)
	else:
		print("Item not found in table.")
