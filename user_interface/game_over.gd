extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$CenterContainer/MarginContainer/VBoxContainer/ScoreLabel.text = "\n\nYour Score: " +  str(score.score) + "\n\n"
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event: InputEvent):
	if event.is_action("escape"):
		on_quit_pressed()
	if event.is_action("play"):
		on_menu_pressed()

func on_quit_pressed():
	get_tree().quit()

func on_menu_pressed():
	score.score = 0
	get_tree().change_scene_to_file("res://world/Map.tscn")
