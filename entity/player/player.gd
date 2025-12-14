extends CharacterBody2D

@export var max_speed = 9000
@export var player_id = 1

var speed = max_speed
var device_id = 1

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

	move_and_slide()
