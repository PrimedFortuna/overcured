extends CharacterBody2D

const SPEED = 260
const RUN_SPEED = 380
var pickup_object = null

@onready var healstation = get_node("../HealStation")
@onready var world = get_parent()

func _ready():
	print("Tables in group:", get_tree().get_nodes_in_group("tables"))


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

	var current_speed = SPEED if not Input.is_action_pressed("ui_shift") else RUN_SPEED
	velocity = direction.normalized() * current_speed
	move_and_slide()

func interact(item = null):
	if item == null:
		item = find_nearest_pickup_item()

	if item and pickup_object == null and global_position.distance_to(item.global_position) < 50:
		print("Picked up Item:", item.name)
		if item.get_parent():
			item.get_parent().remove_child(item)
		pickup_object = item
		add_child(pickup_object)
		pickup_object.position = Vector2(2, 30)
		pickup_object.scale = Vector2(1, 1)
		move_child(pickup_object, 3)
		pickup_object.visible = true
		return

	var nearest_table = find_nearest_table()
	print("Nearest table:", nearest_table)

	if pickup_object == null and nearest_table:
		var last_item = nearest_table.remove_item_from_table()
		if last_item:
			print("Picked up from table:", last_item.name)
			if last_item.get_parent():
				last_item.get_parent().remove_child(last_item)
			pickup_object = last_item
			add_child(pickup_object)
			pickup_object.position = Vector2(2, 30)
			pickup_object.scale = Vector2(1, 1)
			move_child(pickup_object, 3)
			pickup_object.visible = true
			return

	elif pickup_object == null and is_near_healstation():
		var last_item = healstation.remove_item_from_healstation()
		if last_item:
			print("Picked up from healstation:", last_item.name)
			if last_item.get_parent():
				last_item.get_parent().remove_child(last_item)
			pickup_object = last_item
			add_child(pickup_object)
			pickup_object.position = Vector2(2, 30)
			pickup_object.scale = Vector2(1, 1)
			move_child(pickup_object, 3)
			pickup_object.visible = true
			return

	elif pickup_object != null:
		if nearest_table:
			print("Trying to drop item on table:", pickup_object.name)
			remove_child(pickup_object)
			nearest_table.add_item_to_table(pickup_object)
			print("Item new parent after adding to table:", pickup_object.get_parent())
			pickup_object.scale = Vector2(1.2, 1.2)
			pickup_object = null
		elif is_near_healstation():
			if pickup_object.is_in_group("pokeballs"):
				print("Dropped on healstation:", pickup_object.name)
				remove_child(pickup_object)
				healstation.add_item_to_healstation(pickup_object)
				print("Item new parent after adding to healstation:", pickup_object.get_parent())
				pickup_object.scale = Vector2(1.2, 1.2)
				pickup_object = null
			else:
				print("Can't drop this item on the healstation! Only Pokeballs can be dropped here.")
		else:
			print("Dropped on ground:", pickup_object.name)
			if pickup_object.get_parent():
				pickup_object.get_parent().remove_child(pickup_object)
			world.add_child(pickup_object)
			world.move_child(pickup_object, 1)
			pickup_object.global_position = global_position + Vector2(0, 20)
			print("Item new parent after dropping on ground:", pickup_object.get_parent())
			pickup_object.visible = true
			pickup_object.scale = Vector2(2, 2)
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

func find_nearest_table() -> Node:
	var nearest_table = null
	var min_distance = 200
	var tables = get_tree().get_nodes_in_group("tables")


	for table in tables:
		var distance = global_position.distance_to(table.global_position)
		print("Checking distance:", distance)

		if distance < min_distance:
			nearest_table = table
			min_distance = distance

	return nearest_table



func is_near_healstation() -> bool:
	if healstation:
		return global_position.distance_to(healstation.global_position) < 128
	else:
		print("Healstation not found!")
		return false
