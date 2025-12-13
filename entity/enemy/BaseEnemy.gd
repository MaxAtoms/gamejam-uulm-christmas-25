extends Node
class_name BaseEnemy

var path = []
var position: Vector2 = Vector2(-1,-1)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func setPathToTarget(xTarget: int, yTerget: int):		
	path = []
	
