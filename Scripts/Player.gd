extends CharacterBody2D

const SPEED = 150      
const RUN_SPEED = 250  
var pickup_object = null  

@onready var table = get_node("Table")  # Adjust this path based on where the table is in your scene structure

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
	if item and pickup_object == null and global_position.distance_to(item.global_position) < 40: 
		print("Picked up Item")
		pickup_object = item
		item.reparent(self)
		item.position = Vector2(3, 30)
	elif pickup_object != null:
		if is_near_table():
			print("Dropped:", pickup_object.name)
			pickup_object.reparent(table)
			table.add_item_to_table(pickup_object)
			pickup_object = null
		else:
			print("Dropped:", pickup_object.name)
			pickup_object.reparent(get_parent())
			get_parent().move_child(pickup_object,1)
			pickup_object.position = global_position 
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
		return distance_to_table < 50
	else:
		print("Table not found!")
		return false
