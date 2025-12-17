extends Node2D


func on_level_changed(new_level: int) -> void:
	# z.B. neue Skills freischalten
	print("Class reacts to level:", new_level)
