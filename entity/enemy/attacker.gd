extends Area2D

@export var damage = 10
@export var interval = 2
@export var target_groups = ["target", "defence"]

var target: Node2D = null

func _ready() -> void:
	$AttackTimer.wait_time = interval

func _on_body_entered(body: Node2D) -> void:
	if target_groups.any(func (group): return body.is_in_group(group)):
		target = body
		if $AttackTimer.is_stopped():
			target.get_node("Damagable").damage(damage)
			$AttackTimer.start()

func _on_body_exited(body: Node2D) -> void:
	if target == body:
		target = null
		$AttackTimer.stop()

func _on_attack_timer_timeout() -> void:
	if is_instance_valid(target):
		target.get_node("Damagable").damage(damage)
	else:
		target = null
