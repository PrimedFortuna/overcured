extends CharacterBody2D

const SPEED = 180      
const RUN_SPEED = 300  
var pickup_object = null  

@onready var table = get_node("../Table")
@onready var healstation = get_node("../HealStation")
@onready var world = get_parent()  # Reference to the world (ensures proper reparenting)

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

func interact(item = null):
	if item == null:
		item = find_nearest_pickup_item()

	# Picking up an item from the ground
	if item and pickup_object == null and global_position.distance_to(item.global_position) < 50: 
		print("Picked up Item:", item.name)
		if item.get_parent():  # Ensure it has a parent before reparenting
			item.get_parent().remove_child(item)
		pickup_object = item
		add_child(pickup_object)  # Instead of reparent(), use add_child()
		pickup_object.position = Vector2(2, 30)
		move_child(pickup_object, 3)
		pickup_object.visible = true  

	elif pickup_object == null and is_near_table():
		var last_item = table.remove_item_from_table() 
		if last_item:
			print("Picked up from table:", last_item.name)
			if last_item.get_parent():  # Ensure it has a parent before reparenting
				last_item.get_parent().remove_child(last_item)
			pickup_object = last_item
			add_child(pickup_object)
			pickup_object.position = Vector2(2, 30)
			move_child(pickup_object, 3)
			pickup_object.visible = true  
			
	elif pickup_object == null and is_near_healstation():
		var last_item = healstation.remove_item_from_healstation() 
		if last_item:
			print("Picked up from healstation:", last_item.name)
			if last_item.get_parent():
				last_item.get_parent().remove_child(last_item)
			pickup_object = last_item
			add_child(pickup_object)
			pickup_object.position = Vector2(2, 30)
			move_child(pickup_object, 3)
			pickup_object.visible = true  

	elif pickup_object != null:
		if is_near_table():
			print("Dropped on table:", pickup_object.name)
			remove_child(pickup_object)
			table.add_item_to_table(pickup_object)
			pickup_object = null
		elif is_near_healstation():
			# Check if the item is a Pokeball before dropping it on the heal station
			if pickup_object.is_in_group("pokeballs"):
				print("Dropped on healstation:", pickup_object.name)
				remove_child(pickup_object)
				healstation.add_item_to_healstation(pickup_object)
				pickup_object = null
			else:
				print("Can't drop this item on the healstation! Only Pokeballs can be dropped here.")
		else:
			print("Dropped on ground:", pickup_object.name)
			if pickup_object.get_parent():  
				pickup_object.get_parent().remove_child(pickup_object)  # Remove from current parent
			world.add_child(pickup_object)  # Add it to the world
			world.move_child(pickup_object, 1)
			pickup_object.global_position = global_position + Vector2(0, 20)  
			pickup_object.visible = true  
			pickup_object = null

func find_nearest_pickup_item() -> Node:
	var nearest_item = null
	var min_distance = 40  

	for item in get_tree().get_nodes_in_group("pickups"):
		if item and item is Node2D:
			var distance = global_position.distance_to(item.global_position)
			if distance < min_distance:
				nearest_item = item
				min_distance = distance

	return nearest_item

func is_near_table() -> bool:
	if table:
		return global_position.distance_to(table.global_position) < 128
	else:
		print("Table not found!")
		return false
		
func is_near_healstation() -> bool:
	if healstation:
		return global_position.distance_to(healstation.global_position) < 128
	else:
		print("Healstation not found!")
		return false
