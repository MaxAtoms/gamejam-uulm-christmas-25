extends Worker

func _init():
	worker_name = "blacksmith"
	ressource = Iron
	product = Canon
	ressources = []
	consumed_ressources_per_request = 4
	produced_items_per_request = 1
	cooldown_in_sec = 3
	interacting_component = null
