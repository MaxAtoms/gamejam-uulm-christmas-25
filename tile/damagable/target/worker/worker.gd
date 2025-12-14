class_name Worker
extends StaticBody2D

@onready var interactable: Interactable = $Interactable
@onready var crafting_timer: Timer = $Timer
@onready var progress_bar: ProgressBar = $ProgressBar

var worker_name = "worker"
var ressource = Stone
var product = Wall
var ressources: Array[Item] = []
var consumed_ressources_per_request = 2
var produced_items_per_request = 1
var cooldown_in_sec = 1
var interacting_component: InteractingComponent = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	interactable.interact = _on_interact
	interactable.cancel_interaction = _on_cancel_interaction
	crafting_timer.wait_time = cooldown_in_sec
	crafting_timer.timeout.connect(func(): _on_crafting_finished())

func _process(delta: float):
	if crafting_timer.time_left == 0:
		progress_bar.value = 0
		return
	progress_bar.value =  (1 - (crafting_timer.time_left / crafting_timer.wait_time)) * 100

func _on_interact(interacting_component: InteractingComponent):
	if interactable.is_interactable:
		interactable.is_interactable = false
		
		if interacting_component.get_item_type() == ressource.get_type():
			# Player has items and wants to put them down
			print("Take all items")
			ressources.append_array(interacting_component.take_all_items())
			interactable.is_interactable = true
			return
		
		# If the player holds items that cannot be placed down, we will not allow to craft
		# Crafting can only be done if the bag is emtpy
		if interacting_component.get_item_type() != "":
			interactable.is_interactable = true
			return
		
		# Player wants to craft an item
		if ressources.size() < consumed_ressources_per_request:
			# There are not enough ressources to craft anything
			interactable.is_interactable = true
			return
		
		# Can craft item => so start crafting
		self.interacting_component = interacting_component
		crafting_timer.start()

func _on_crafting_finished():
	crafting_timer.stop()
	if interacting_component != null:
		print("The ", worker_name, " provided ", produced_items_per_request," ", product.get_type(), " for interacting component ", interacting_component.id, ".")
		ressources = ressources.slice(0, -consumed_ressources_per_request)
		interacting_component.receive_items([product.new()])
	interacting_component = null
	interactable.is_interactable = true

func _on_cancel_interaction(interacting_component: InteractingComponent):
	print("Cancle for ", interacting_component.id)
	if self.interacting_component != null && interacting_component.id == self.interacting_component.id:
		crafting_timer.stop()
		self.interacting_component = null
		interactable.is_interactable = true

func _on_interactable_area_exited(interacting_component: InteractingComponent) -> void:
	_on_cancel_interaction(interacting_component)
