extends Node2D

@export var damage = 1

@onready var main = get_tree().get_root().get_node("Map")
@onready var projectile = load("res://tile/damagable/buildable/defence/Projectile.tscn")

func _ready() -> void:
	shoot()

func _process(_delta: float) -> void:
	pass

func shoot():
	var instance = projectile.instantiate()
	instance.dir = rotation
	instance.spawnPos = global_position
	instance.spawnRot = rotation
	instance.damage = damage
	main.add_child.call_deferred(instance)


func _on_cooldown_timeout() -> void:
	shoot()
