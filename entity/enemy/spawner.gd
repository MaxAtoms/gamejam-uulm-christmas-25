class_name Spawner
extends Node2D

# Denotes in which round the spawner gets active
@export var retardation = 1

@export var radius = 50
@export var start_amount = 5
@export var increment = 2

@export var enemy_scene = preload("res://entity/enemy/Goblin.tscn")

var current_round = 0
var enemies = []

func _ready() -> void:
	get_parent().phase_change.connect(_on_map_phase_change)

func is_round_completed() -> bool:
	return enemies.all(func (enemy): not is_instance_valid(enemy))

func random_pos() -> Vector2:
	var distance = randf_range(0, radius)
	var angle = 2*PI * distance
	
	return distance * Vector2(cos(angle), sin(angle))

func _on_map_phase_change(phase, round_count: int) -> void:
	if phase == Phase.NIGHT && round_count >= retardation:
		spawn(round_count)

func spawn(round_count: int) -> void:
	var amount = start_amount + (round_count - retardation) * increment
	print("Spawner triggered, Round:", round_count, " Spanning: ", amount)
	
	for i in range(0, amount):
		var spawn_pos = random_pos()
		var enemy = enemy_scene.instantiate()
		enemy.global_position = spawn_pos
		add_child(enemy)
		enemies.append(enemy)
