class_name Interactable
extends Area2D

@export var interact_name: String = ""
@export var is_interactable: bool = true

var interact = func(interacting_component: InteractingComponent, items: Array[Item]) -> Array[Item]:
	return []

var cancel_interaction = func(interacting_component: InteractingComponent):
	pass
