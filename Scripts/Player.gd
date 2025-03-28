extends CharacterBody2D

const SPEED = 150      
const RUN_SPEED = 250  
var is_near_pickup = false
var pickup_object = null

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
	
func _on_area_entered(area):
	print("Player entered area")
	if area.is_in_group("pickups"):
		is_near_pickup = true
		pickup_object = area

func _on_area_exited(area):
	if area.is_in_group("pickups"):
		is_near_pickup = false
		pickup_object = null

func _input(event):
	if event.is_action_pressed("ui_select") and is_near_pickup:
		pickup()
		
func pickup():
	if pickup_object:
		print("Picked up " + pickup_object.name)
		pickup_object.queue_free()
