extends Worker


func _init():
	worker_name = "stonemason"
	ressource = Stone
	product = Wall
	ressources = []
	consumed_ressources_per_request = 2
	produced_items_per_request = 2
	cooldown_in_sec = 1
	interacting_component = null
