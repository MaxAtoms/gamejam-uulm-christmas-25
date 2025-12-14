extends BaseEnemy

@onready var damagable = $Damagable

func _on_death() -> void:
	queue_free()

func walkanimation():
	$GoblinAnimation.play()
	
	if velocity.x > 0:
		$GoblinAnimation.animation = "go_right"
		direction = Direction.RIGHT
	elif velocity.x < 0:
		$GoblinAnimation.animation = "go_left"
		direction = Direction.LEFT
	elif velocity.y > 0:
		$GoblinAnimation.animation = "go_down"
		direction = Direction.DOWN
	elif velocity.y < 0:
		$GoblinAnimation.animation = "go_up"
		direction = Direction.UP
	else:
		$GoblinAnimation.animation = "idle_" + Direction.keys()[direction].to_lower()
