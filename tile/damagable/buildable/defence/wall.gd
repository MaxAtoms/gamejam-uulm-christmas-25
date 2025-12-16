extends StaticBody2D

@onready var main = get_tree().get_root().get_node("Map")
@onready var rubble_scene = preload("res://tile/damagable/buildable/defence/Rubble.tscn")

func _on_damagable_on_death() -> void:
	queue_free()
	var rubble = rubble_scene.instantiate()
	rubble.global_position = global_position
	main.add_child(rubble)
