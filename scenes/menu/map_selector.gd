extends PanelContainer

@onready var prev = $MarginContainer/VBoxContainer/HBoxContainer/prev
@onready var next = $MarginContainer/VBoxContainer/HBoxContainer/next

func _process(delta):
	if(!multiplayer.get_unique_id() == 1):
		prev.disabled = true
		next.disabled = true

func getMap()->int:
	return 1
