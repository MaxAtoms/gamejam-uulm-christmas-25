extends Area2D

@onready var interactable: Area2D = $Interactable

const PRODUCT: String = "iron"
var produced_items_per_request = 1
var cooldown_in_sec = 5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	interactable.interact = _on_interact
	interactable.cancel_interaction = _on_cancel_interaction
	
func _on_interact(interacting_component: InteractingComponent, _items: Array[Item]) -> Array[Item]:
	if interactable.is_interactable:
		interactable.is_interactable = false
		await get_tree().create_timer(cooldown_in_sec).timeout
		print("the mine provided ", produced_items_per_request," iron")
		interactable.is_interactable = true
		var mined_items: Array[Item] = []
		for i in range(produced_items_per_request):
			mined_items.append(Iron.new())
		return mined_items
	return []

func _on_cancel_interaction(interacting_component: InteractingComponent):
	pass
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
