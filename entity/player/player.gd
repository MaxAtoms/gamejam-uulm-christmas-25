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

var bag: Bag = Bag.new()

@onready var map = get_node("/root/Map")

func _ready():
	bag.add_item([ArcherTower.new()])
	map.refresh_inventory_display(device_id, bag.get_item_count(), bag.get_item_type(), bag.get_size())

func _physics_process(delta: float) -> void:
	player_movement(delta)

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
	print(Iron.new().get_type())
	print(Item.new().get_type())
	if items.size() == 0:
		print("The player did not receive an item from the mine")
		return
	var added_items = bag.add_item(items)
	if added_items == -1:
		print("This player cannot carry this type of item")
	elif added_items == 0:
		print("The bag is full")
	else:
		print("Added ", items.size(), " items to the bag")
	
	map.refresh_inventory_display(device_id, bag.get_item_count(), bag.get_item_type(), bag.get_size())
