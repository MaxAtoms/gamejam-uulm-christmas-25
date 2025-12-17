extends Node2D

@export var startingLevel = 1
@export var maxLevel = 10

signal level_changed(new_level: int)

var currentLevel = startingLevel
var currentExp = 0
var expThreashold = 0

func gainExp(exp: int):
	currentExp += exp
	if currentExp > expThreashold:
		levelUp()
		currentExp -= expThreashold
		calcThreshhold()
	
func levelUp():
	if currentLevel+1 > maxLevel:
		return
	currentLevel += 1	
	emit_signal("level_changed", currentLevel)
	
func calcThreshhold():
	expThreashold = 110 * startingLevel


func _on_timer_timeout() -> void:
	gainExp(100)
