extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

@export var day_length := 20.0

@export var night_color := Color(0.05, 0.05, 0.4, 0.5)
var curve_strength := 2.0 # higher = more square
@onready var night_color_rect = $CanvasLayer/ColorRect
@onready var time_label = $CanvasLayer2/Control/MarginContainer/HBoxContainer/Label

var time := day_length / 2
var is_night := false

@export var max_player = 4
var players = {}

func _process(delta):
	
	var enemies_present: bool = get_node("Spawner").get_child_count() > 0
				
	time += delta
	if time > day_length:
		time -= day_length
	var cycle := (time / day_length) * TAU

	# Modified to have more equal day/night duration
	var raw := (sin(cycle) + 1) / 2
	raw = raw * raw * (3 - 2 * raw)  # smoothstep to equalize day/night
	var night_strength := pow(raw, curve_strength)

	if night_color_rect != null:
		night_color_rect.color.a = night_color.a * night_strength
		night_color_rect.color.r = night_color.r
		night_color_rect.color.g = night_color.g
		night_color_rect.color.b = night_color.b

	# Day / night state
	is_night = night_strength > 0.5
	
	if time > day_length / 4 and time < day_length / 2 and enemies_present:
		time = day_length / 4
	
	if time_label != null:
		time_label.text = "Current Time: " + ("Night" if is_night else "Day") + "  " + str(time)
	
func _input(event: InputEvent) -> void:
	var deviceId = event.device
	
	if not players.has(deviceId):
	
		var playerScene = preload("res://entity/player/Player.tscn")
		var player = playerScene.instantiate()
		player.position = Vector2(800, 800)
		
		player.device_id = deviceId
		players.set(deviceId, player)  
		
		add_child(player)
	#if InputEventJoypadMotion:
		#print("test")
