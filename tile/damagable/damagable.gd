class_name Damagable
extends Node2D

@export var max_health: float = 100
@export var bar_visible_seconds: float = 2
@export var bar_color: Color = Color.WHITE
@export var bar_offset: float = 0
@export var auto_hide = true

signal on_damage
signal on_death

var health: float = max_health

func _ready() -> void:
	$HealthBar.max_value = max_health
	$HealthBar.value = health
	if auto_hide: $HealthBar.hide()
	$HealthBar.position += Vector2(0, -bar_offset)
	var style = StyleBoxFlat.new()
	style.bg_color = bar_color
	style.shadow_color = Color.BLACK
	$HealthBar.add_theme_stylebox_override("fill", style)

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
	if auto_hide: $HealthBar.hide()
