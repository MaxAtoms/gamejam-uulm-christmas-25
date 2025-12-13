extends Node2D

@export var max_health: float = 100
@export var bar_visible_seconds = 2
@onready var bar_timer = $BarTimer

signal on_damage
signal on_death

var health: float = max_health

func _ready() -> void:
	$HealthBar.max_value = max_health
	$HealthBar.value = health
	$HealthBar.hide()

func damage(amount: float) -> void:
	if health <= 0:
		return
	health = max(health - amount, 0)
	update_bar()
	
	on_damage.emit(amount)
	if health <= 0:
		on_death.emit()

func heal(amount: float) -> void:
	health = min(health + amount, max_health)
	update_bar()

func update_bar() -> void:
	$HealthBar.show()
	$HealthBar.value = health
	$BarTimer.wait_time = bar_visible_seconds
	$BarTimer.start()

func _on_bar_timer() -> void:
	$HealthBar.hide()
