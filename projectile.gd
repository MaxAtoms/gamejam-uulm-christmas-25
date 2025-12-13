extends CharacterBody2D

@export var speed = 100
@export var damage = 10

var dir : float
var spawnPos : Vector2
var spawnRot : float

func _ready():
	global_position = spawnPos
	global_rotation = spawnRot

func _physics_process(_delta: float) -> void:
	velocity = Vector2(0, speed).rotated(dir)
	move_and_slide()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		print("Hit an enemy :)")
	#queue_free()


func _on_lifetime_timeout() -> void:
	pass
	#queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
