extends Worker

func _init():
	worker_name = "craftsman"
	ressource = Wood
	product = ArcherTower
	ressources = []
	consumed_ressources_per_request = 5
	produced_items_per_request = 1
	cooldown_in_sec = 2
	interacting_component = null
