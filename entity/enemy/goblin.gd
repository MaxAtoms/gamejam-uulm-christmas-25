extends BaseEnemy

@onready var damagable = $Damagable

func _on_death() -> void:
	queue_free()
