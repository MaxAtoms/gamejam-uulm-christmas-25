extends Area2D

@export var speed = 100

var damage : int
var dir : float
var spawnPos : Vector2
var spawnRot : float

func _ready():
	global_position = spawnPos
	global_rotation = spawnRot

func _physics_process(delta: float) -> void:
	var movement = Vector2(0,speed) * delta
	position += movement

func _on_lifetime_timeout() -> void:
	pass
	#queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	print(body.name)
	if body.is_in_group("enemy"):
		print("Hit enemy!")
		body.get_node("Damagable").damage(damage)
		queue_free()
