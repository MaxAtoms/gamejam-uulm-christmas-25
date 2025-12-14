class_name InteractingComponent
extends Node2D

@onready var interact_label: Label = $InteractLabel
var current_interactions := []
var can_interact := true
var id = Time.get_ticks_msec()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and event.device == get_parent().device_id and can_interact:
		if current_interactions:
			can_interact = false
			interact_label.hide()
			await current_interactions[0].interact.call(self)
			can_interact = true

func get_item_type() -> String:
	return get_parent().get_item_type()

func take_all_items() -> Array[Item]:
	return get_parent().take_all_items()

func receive_items(items: Array[Item]):
	get_parent().receive_items(items)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if current_interactions and can_interact:
		current_interactions.sort_custom(_sort_by_nearest)
		if current_interactions[0].is_interactable:
			interact_label.text = current_interactions[0].interact_name
			interact_label.show()
	else:
		interact_label.hide()

func _sort_by_nearest(area1, area2):
	var area1_dist = global_position.distance_to(area1.global_position)
	var area2_dist = global_position.distance_to(area2.global_position)
	return area1_dist < area2_dist

func _on_interact_range_area_entered(area: Interactable) -> void:
	current_interactions.push_back(area)

func _on_interact_range_area_exited(area: Interactable) -> void:
	await area.cancel_interaction.call(self)
	current_interactions.erase(area)
