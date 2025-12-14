class_name BaseEnemy
extends CharacterBody2D

@export var speed = 5000
@export var damage = 1
@export var target_randomness = 0.2

var target: Node = null

func _ready() -> void:
	target = find_target()

func _process(delta: float) -> void:
	if not is_instance_valid(target):
		find_target()
	if target != null:
		velocity = target.global_position - global_position
		velocity = velocity.normalized() * speed * delta
		move_and_slide()

func find_target():
	var targetNodes = get_tree().get_nodes_in_group("target")
	var minDistanceSquared = INF
	
	for targetNode in targetNodes:
		var distanceSquared = global_position.distance_squared_to(targetNode.global_position)
		if distanceSquared <= minDistanceSquared && randf() >= target_randomness:
			minDistanceSquared = distanceSquared
			target = targetNode
