extends Node2D

signal phase_change

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


var round_counter = 0
var phase = Phase.DAY
@export var day_length := 20.0

@export var night_color := Color(0.05, 0.05, 0.4, 0.5)
var curve_strength := 2.0 # higher = more square
@onready var night_color_rect = $CanvasLayer/ColorRect
@onready var time_label = $CanvasLayer2/Control/MarginContainer/HBoxContainer/Label

var time := 4 #day_length / 2
var is_night := false

@export var max_player = 4
var players = {}

#Dict of device id -> [item type, item amount]
var inventory_values: Dictionary[int, Array] = {}

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
	
	if is_night && phase == Phase.DAY:
		phase = Phase.NIGHT
		round_counter = round_counter + 1
		phase_change.emit(phase, round_counter)
		print("Night phase started, Round: ", round_counter)
	elif !is_night && phase == Phase.NIGHT:
		phase = Phase.DAY
		phase_change.emit(phase, round_counter)
		print("Day phase started, Round: ", round_counter)
	
	if time > day_length / 4 and time < day_length / 2 and enemies_present:
		time = day_length / 4
	
	if time_label != null:
		time_label.text = "Current Time: " + ("Night" if is_night else "Day  ")
	
func _input(event: InputEvent) -> void:
	var deviceId = event.device
	
	if not players.has(deviceId):
		print(Input.get_connected_joypads())
		var playerScene = preload("res://entity/player/Player.tscn")
		var player = playerScene.instantiate()
		player.position = Vector2(800, 800)
		
		player.device_id = deviceId
		players.set(deviceId, player)  
		
		add_child(player)
	#if InputEventJoypadMotion:
		#print("test")
	
func goto_main_menu():
	get_tree().quit()

func refresh_inventory_display(device_id: int, amount: int, item_type: String, bag_size: int):
	
	for child in get_node("CanvasLayer2/Control/MarginContainer/HBoxContainer/HBoxContainer").get_children():
			child.queue_free()
			
	inventory_values[device_id] = [item_type, amount]
	
	var sorted_keys = inventory_values.keys()
	sorted_keys.sort()
	
	var font = load("res://tile/fonts/Righteous.ttf")  # FontFile resource
	
	for player_id in sorted_keys:
		print("Player " + str(player_id))
		
		var icon_path = "res://tile/icon/wood.png"	
		if inventory_values.get(player_id)[0] == "iron":
			icon_path = "res://tile/icon/iron.png"
		elif inventory_values.get(player_id)[0] == "stone":
			icon_path = "res://tile/icon/stone.png"
		elif inventory_values.get(player_id)[0] == "archer_tower":
			icon_path = "res://tile/damagable/buildable/defence/ArcherTower2.png"
		elif inventory_values.get(player_id)[0] == "canon":
			icon_path = "res://tile/damagable/buildable/defence/canon.png"
		
		var name_label = Label.new()
		name_label.text = "Player " + str(player_id) + ": "	
		name_label.add_theme_font_override("font", font)
		name_label.add_theme_font_size_override("font_size", 10)
		get_node("CanvasLayer2/Control/MarginContainer/HBoxContainer/HBoxContainer").add_child(name_label)
		
		var icon = TextureRect.new()
		icon.texture = load(icon_path)  # Load your icon texture
		icon.expand_mode = TextureRect.EXPAND_KEEP_SIZE     # Preserve original size
		icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		icon.custom_minimum_size = Vector2(32, 32)           # Optional: fixed icon size
		get_node("CanvasLayer2/Control/MarginContainer/HBoxContainer/HBoxContainer").add_child(icon)
		
		var amount_label = Label.new()
		amount_label.text = str(inventory_values.get(player_id)[1]) + " / " + str(bag_size)
		amount_label.add_theme_font_override("font", font)
		amount_label.add_theme_font_size_override("font_size", 10)
		get_node("CanvasLayer2/Control/MarginContainer/HBoxContainer/HBoxContainer").add_child(amount_label)
		
		
		var fixed_spacer = Control.new()
		fixed_spacer.custom_minimum_size = Vector2(16, 0)
		get_node("CanvasLayer2/Control/MarginContainer/HBoxContainer/HBoxContainer").add_child(fixed_spacer)
