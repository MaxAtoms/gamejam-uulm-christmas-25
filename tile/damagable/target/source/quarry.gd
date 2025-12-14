extends StaticBody2D

@onready var interactable: Interactable = $Interactable
@onready var mining_timer: Timer = $Timer
@onready var progress_bar: ProgressBar = $ProgressBar

var produced_items_per_request = 1
var cooldown_in_sec = 2
var interacting_component: InteractingComponent = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	interactable.interact = _on_interact
	interactable.cancel_interaction = _on_cancel_interaction
	mining_timer.wait_time = cooldown_in_sec
	mining_timer.timeout.connect(func(): _on_mining_finished())
	
func _process(delta: float):
	if mining_timer.time_left == 0:
		progress_bar.value = 0
		return
	progress_bar.value =  (1 - (mining_timer.time_left / mining_timer.wait_time)) * 100

func _on_interact(interacting_component: InteractingComponent, _items: Array[Item]):
	if interactable.is_interactable:
		interactable.is_interactable = false
		self.interacting_component = interacting_component
		mining_timer.start()

func _on_mining_finished():
	mining_timer.stop()
	if interacting_component != null:
		print("The mine provided ", produced_items_per_request," stone for interacting component ", interacting_component.id, ".")
		var mined_items: Array[Item] = []
		for i in range(produced_items_per_request):
			mined_items.append(Stone.new())
		interacting_component.receive_items(mined_items)
	interacting_component = null
	interactable.is_interactable = true

func _on_cancel_interaction(interacting_component: InteractingComponent):
	print("Cancle for ", interacting_component.id)
	if self.interacting_component != null && interacting_component.id == self.interacting_component.id:
		mining_timer.stop()
		self.interacting_component = null
		interactable.is_interactable = true

func _on_interactable_area_exited(interacting_component: InteractingComponent) -> void:
	_on_cancel_interaction(interacting_component)
