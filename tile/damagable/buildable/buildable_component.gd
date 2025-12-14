extends Node2D

@onready var main = get_tree().get_root().get_node("Map")

static var tower = preload("res://tile/damagable/buildable/defence/ArcherTower.tscn")
static var canon = preload("res://tile/damagable/buildable/defence/Canon.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("build"):
		var bag_type = get_parent().get_bag_type()
		if bag_type != "archer_tower" and bag_type != "canon":
			print("No buildable item in bag")
			return

		var instance
		if bag_type == "archer_tower":
			instance = tower.instantiate()
		else:
			instance = canon.instantiate()
		instance.global_position = global_position.snapped(Vector2.ONE * 32)
		main.add_child(instance)
		get_parent().take_item()
		pass
