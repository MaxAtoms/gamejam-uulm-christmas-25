extends Worker

@onready var main = get_tree().get_root().get_node("Map")
@onready var rubble_scene = preload("res://tile/damagable/buildable/defence/Rubble.tscn")

func _init():
	worker_name = "stonemason"
	ressource = Stone
	product = Wall
	ressources = []
	consumed_ressources_per_request = 2
	produced_items_per_request = 2
	cooldown_in_sec = 1
	interacting_component = null

func _on_damagable_on_death() -> void:
	queue_free()
	var rubble = rubble_scene.instantiate()
	rubble.global_position = global_position
	main.add_child(rubble)
