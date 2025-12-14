extends StaticBody2D

@onready var interactable: Area2D = $Interactable
@onready var timer: Timer = $Timer

const PRODUCT: String = "iron"
var produced_items_per_request = 1
var cooldown_in_sec = 2
var interacting_component: InteractingComponent = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	interactable.interact = _on_interact
	interactable.cancel_interaction = _on_cancel_interaction
	timer.timeout.connect(func(): print("Hallo"))

	
func _on_interact(interacting_component: InteractingComponent, _items: Array[Item]) -> Array[Item]:
	if interactable.is_interactable:
		interactable.is_interactable = false
		self.interacting_component = interacting_component
		await get_tree().create_timer(cooldown_in_sec).timeout
		print("the mine provided ", produced_items_per_request," iron")
		var mined_items: Array[Item] = []
		if self.interacting_component != null and interacting_component.id == self.interacting_component.id:
			for i in range(produced_items_per_request):
				mined_items.append(Iron.new())
		self.interacting_component = null
		interactable.is_interactable = true
		return mined_items
	return []

func _on_cancel_interaction(interacting_component: InteractingComponent):
	self.interacting_component = null
	print("Cancle for ", interacting_component.id)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_interactable_area_exited(interacting_component: InteractingComponent) -> void:
	_on_cancel_interaction(interacting_component)
