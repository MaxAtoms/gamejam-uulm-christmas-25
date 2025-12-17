extends Node2D

@export var projectile_damage = 20
@export var projectile_speed = 500
@export var target_range = 300
@export var shoot_interval = 0.5
@export var projectile = preload("res://tile/damagable/buildable/defence/projectile/Arrow.tscn")

@onready var main = get_tree().get_root().get_node("Map")

var target: Node2D = null

func _ready() -> void:
	$Cooldown.wait_time = shoot_interval
	shoot()

func shoot():
	find_target()
	if target != null:
		var instance = projectile.instantiate()
		instance.position = global_position
		instance.direction = target.global_position - global_position
		instance.damage = projectile_damage
		instance.speed = projectile_speed
		main.add_child(instance)

func find_target():
	var targetNodes = get_tree().get_nodes_in_group("enemy")
	var minDistanceSquared = INF
	target = null

	for targetNode in targetNodes:
		var distanceSquared = global_position.distance_squared_to(targetNode.global_position)
		if distanceSquared <= minDistanceSquared && distanceSquared <= target_range * target_range:
			minDistanceSquared = distanceSquared
			target = targetNode
			

func _on_cooldown_timeout() -> void:
	shoot()
