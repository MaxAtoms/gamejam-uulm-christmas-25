extends Node2D

@export var max_player = 4

var players = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	
	
func _input(event: InputEvent) -> void:
	var deviceId = event.device
	print(Input.get_connected_joypads())
	if not players.has(deviceId) and InputEventJoypadButton:
	
		var playerScene = preload("res://entity/player/Player.tscn")
		var player = playerScene.instantiate()
		print("ID: " ,deviceId)
		player.device_id = deviceId
		players.set(deviceId, player)  
		
		add_child(player)
	
	#if InputEventJoypadMotion:
		#print("test")
