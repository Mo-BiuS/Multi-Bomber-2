extends PanelContainer

@onready var bombSpin:SpinBox = $MarginContainer/VBoxContainer/bombSpin
@onready var speedSpin:SpinBox = $MarginContainer/VBoxContainer/speedSpin
@onready var powerSpin:SpinBox = $MarginContainer/VBoxContainer/powerSpin

func _process(delta):
	if(!multiplayer.get_unique_id() == 1):
		bombSpin.editable = false
		speedSpin.editable = false
		powerSpin.editable = false

func getBomb()->int:
	return bombSpin.value
func getSpeed()->int:
	return speedSpin.value
func getPower()->int:
	return powerSpin.value
