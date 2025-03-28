extends CharacterBody2D

const SPEED = 180      
const RUN_SPEED = 300  
var pickup_object = null  

@onready var table = get_node("../Table")

func _ready():
	print("Player script is running!")

func _physics_process(_delta):
	var direction = Vector2.ZERO

	if Input.is_action_pressed("ui_right"):
		direction.x += 1
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
	if Input.is_action_pressed("ui_down"):
		direction.y += 1
	if Input.is_action_pressed("ui_up"):
		direction.y -= 1

	var current_speed = SPEED
	if Input.is_action_pressed("ui_shift"): 
		current_speed = RUN_SPEED

	velocity = direction.normalized() * current_speed
	move_and_slide()

func interact(item):
	if item and pickup_object == null and global_position.distance_to(item.global_position) < 50: 
		print("Picked up Item")
		pickup_object = item
		
		if item.get_parent():
			item.get_parent().remove_child(item)
		
		item.reparent(self)  
		item.position = Vector2(2, 30)
		move_child(item, 1)
		item.visible = true
		
	elif pickup_object == null and is_near_table():  #FILO
		var last_item = table.remove_item_from_table() 
		if last_item:
			print("Picked up from table:", last_item.name)
			pickup_object = last_item
			pickup_object.reparent(self)
			pickup_object.position = Vector2(2, 30)

	elif pickup_object != null:
		if is_near_table():
			print("Dropped:", pickup_object.name)
			
			# Before adding to table, ensure item is reparented and added to the table properly
			if pickup_object.get_parent() != table:
				pickup_object.reparent(table)  # Reparent item to table
			table.add_item_to_table(pickup_object)  # Add to table
			pickup_object = null
		else:
			print("Dropped:", pickup_object.name)
			if pickup_object.get_parent() != get_parent():
				pickup_object.reparent(get_parent())  # Reparent to original parent
			get_parent().move_child(pickup_object, 1)  # Move item to its original parent
			pickup_object.position = global_position  # Drop the item where the player is
			pickup_object = null

func find_nearest_pickup_item() -> Node:
	var nearest_item = null
	var min_distance = 40

	for area in get_tree().get_nodes_in_group("pickups"):
		if area and area is Node2D:
			var distance = global_position.distance_to(area.global_position) 
			if distance < min_distance:
				nearest_item = area
				min_distance = distance

	return nearest_item


func is_near_table() -> bool:
	if table != null:
		var table_position = table.global_position
		var distance_to_table = global_position.distance_to(table_position)
		return distance_to_table < 128
	else:
		print("Table not found!")
		return false
