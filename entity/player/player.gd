class_name Player
extends CharacterBody2D

@export var max_speed = 9000
@export var player_id = 1
enum Direction {
	LEFT,
	RIGHT,
	UP,
	DOWN
}

var speed = max_speed
var device_id = 1
var direction = Direction.DOWN
var add_item_label_cooldown = 0.0

@onready var info_label = get_node("AddItemLabel")

var bag: Bag = Bag.new()

@onready var map = get_node("/root/Map")

func _physics_process(delta: float) -> void:
	player_movement(delta)
	
func _process(delta: float) -> void:
	if add_item_label_cooldown > 0.0:
		add_item_label_cooldown -= delta
		
		if add_item_label_cooldown <= 0.0:
			add_item_label_cooldown = 0.0
			info_label.text = ""

func show_info_on_label(info: String):
	info_label.text = info
	add_item_label_cooldown = 2.0

func player_movement(delta):
	if Input.get_action_strength("move_right_%s" % [device_id]):
		velocity.x = 1
	elif Input.get_action_strength("move_left_%s" % [device_id]):
		velocity.x = -1
	else:
		velocity.x = 0
		
	if Input.get_action_strength("move_down_%s" % [device_id]):
		velocity.y = 1
	elif Input.get_action_strength("move_up_%s" % [device_id]):
		velocity.y = -1
	else:
		velocity.y = 0

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed * delta
		
		
	$AnimatedSprite2D.play()

	if velocity.x > 0:
		$AnimatedSprite2D.animation = "go_right" + str(device_id)
		direction = Direction.RIGHT
	elif velocity.x < 0:
		$AnimatedSprite2D.animation = "go_left" + str(device_id)
		direction = Direction.LEFT
	elif velocity.y > 0:
		$AnimatedSprite2D.animation = "go_down" + str(device_id)
		direction = Direction.DOWN
	elif velocity.y < 0:
		$AnimatedSprite2D.animation = "go_up" + str(device_id)
		direction = Direction.UP
	else:
		$AnimatedSprite2D.animation = "idle_" + Direction.keys()[direction].to_lower() + str(device_id)
	
		
	move_and_slide()
	

func receive_items(items: Array[Item]):
	if items.size() == 0:
		show_info_on_label("No Items received")
		return
	var added_items = bag.add_item(items)
	if added_items == -1:
		show_info_on_label("Can only carry one type of item")
	elif added_items == 0:
		show_info_on_label("Your bag is already full")
	else:
		print("Added ", items.size(), " items to the bag")

	map.refresh_inventory_display(device_id, bag.get_item_count(), bag.get_item_type(), bag.get_size())

		
	#map.refresh_inventory_display(device_id, bag.get_size(), bag.get_item_type())
