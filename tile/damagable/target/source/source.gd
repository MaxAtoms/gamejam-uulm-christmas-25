class_name Source
extends StaticBody2D

@onready var damagable: Damagable = $Damagable
@onready var interactable: Interactable = $Interactable
@onready var mining_timer: Timer = $Timer
@onready var progress_bar: ProgressBar = $ProgressBar

@onready var main = get_tree().get_root().get_node("Map")
@onready var rubble_scene = preload("res://tile/damagable/buildable/defence/Rubble.tscn")

var source_name = "source"
var product = Wood
var produced_items_per_request = 1
var cooldown_in_sec = 1
var interacting_component: InteractingComponent = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	interactable.interact = _on_interact
	interactable.cancel_interaction = _on_cancel_interaction
	mining_timer.wait_time = cooldown_in_sec
	mining_timer.timeout.connect(func(): _on_mining_finished())
	damagable.on_death.connect(_on_death)

func _process(delta: float) -> void:
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
		print("The ", source_name, " provided ", produced_items_per_request," ", product.get_type(), " for interacting component ", interacting_component.id, ".")
		var mined_items: Array[Item] = []
		for i in range(produced_items_per_request):
			mined_items.append(product.new())
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

func _on_death() -> void:
	queue_free()
	var rubble = rubble_scene.instantiate()
	rubble.global_position = global_position
	main.add_child(rubble)
