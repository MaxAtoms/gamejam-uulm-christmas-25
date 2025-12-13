extends Node2D

@export var max_player = 4

var players = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	
	
func _input(event: InputEvent) -> void:
	var deviceId = event.device
	
	if not players.has(deviceId):
	
		var playerScene = preload("res://entity/player/Player.tscn")
		var player = playerScene.instantiate()
		
		player.device_id = deviceId
		players.set(deviceId, player)  
		
		add_child(player)
	
	#if InputEventJoypadMotion:
		#print("test")
