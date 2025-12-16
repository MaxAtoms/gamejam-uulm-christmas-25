extends Node2D
signal phase_change

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


var round_counter = 0
var phase = Phase.DAY
@export var day_length := 60.0

@export var night_color := Color(0.05, 0.05, 0.4, 0.5)
var curve_strength := 2.0 # higher = more square
@onready var night_color_rect = $CanvasLayer/ColorRect
@onready var time_label = $TitleBar/Control/MarginContainer/HBoxContainer/Label
@onready var inventory_container: HBoxContainer = $TitleBar/Control/MarginContainer/HBoxContainer/Inventory


var time := day_length / 2
var is_night := false

@export var max_player = 4
var players: Dictionary[int, Player] = {}

#Dict of device id -> [item type, item amount]
var inventory_values: Dictionary[int, Array] = {}

func _process(delta):
	update_inventory_display()
	if get_tree().get_nodes_in_group("target").size() < 1:
		get_tree().change_scene_to_file("res://user_interface/game_over.tscn")
		
	
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
		
	score.score = round_counter * 100
	
func _input(event: InputEvent) -> void:
	if event.is_action("escape"):
		goto_main_menu()
	
	for i in range(0,3):
		if (event.is_action("move_down_%s" % i) or event.is_action("move_up_%s" % i) or event.is_action("move_left_%s" % i) or event.is_action("move_right_%s" % i)) and not players.has(i):
			print("Player ", i, " connected.")
			var playerScene = preload("res://entity/player/Player.tscn")
			var player = playerScene.instantiate()
			player.position = Vector2(800, 800)
			
			player.device_id = i
			players.set(i, player)
			
			add_child(player)

func goto_main_menu():
	get_tree().change_scene_to_file("res://user_interface/main_menu.tscn")

func update_inventory_display():
	for child in inventory_container.get_children():
		child.queue_free()
	
	for index in players:
		var player: Player = players.get(index)
		
		var item_type = player.get_bag_type()
		if item_type == Item.get_type():
			continue
		
		var font = load("res://tile/fonts/Righteous.ttf")
		
		var player_icon = TextureRect.new()
		match index:
			0: player_icon.texture = load("res://tile/penguin/default/front1.png")
			1: player_icon.texture = load("res://tile/penguin/air/air_front1.png")
			2: player_icon.texture = load("res://tile/penguin/fire/tuxfire_front1.png")
			3: player_icon.texture = load("res://tile/penguin/ice/tuxice_front1.png")
		player_icon.expand_mode = TextureRect.EXPAND_FIT_HEIGHT
		player_icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		player_icon.custom_minimum_size = Vector2(32, 32)
		inventory_container.add_child(player_icon)
		
		var separator_label = Label.new()
		separator_label.text = ": "	
		separator_label.add_theme_font_override("font", font)
		separator_label.add_theme_font_size_override("font_size", 10)
		inventory_container.add_child(separator_label)
		
		var item_icon = TextureRect.new()
		item_icon.texture = load(player.bag.get_item_type_class().get_sprite_path())  # Load your icon texture
		item_icon.expand_mode = TextureRect.EXPAND_KEEP_SIZE     # Preserve original size
		item_icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		item_icon.custom_minimum_size = Vector2(32, 32)           # Optional: fixed icon size
		inventory_container.add_child(item_icon)
		
		var amount_label = Label.new()
		amount_label.text = str(player.bag.get_item_count()) + " / " + str(player.bag.get_size())
		amount_label.add_theme_font_override("font", font)
		amount_label.add_theme_font_size_override("font_size", 10)
		inventory_container.add_child(amount_label)
		
		
		var fixed_spacer = Control.new()
		fixed_spacer.custom_minimum_size = Vector2(16, 0)
		inventory_container.add_child(fixed_spacer)
