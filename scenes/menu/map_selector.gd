extends PanelContainer

@onready var mapName = $MarginContainer/VBoxContainer/PanelContainer/MarginContainer/name
@onready var prev = $MarginContainer/VBoxContainer/HBoxContainer/prev
@onready var next = $MarginContainer/VBoxContainer/HBoxContainer/next

const maxMap = 2
var selectedMap = 0

func _ready():
	refreshMap()

func _process(delta):
	if(!multiplayer.get_unique_id() == 1):
		prev.disabled = true
		next.disabled = true

func getMapId()->int:
	return selectedMap

func _on_prev_pressed():
	if selectedMap == 0: selectedMap = maxMap
	else: selectedMap-=1
	refreshMap()

func _on_next_pressed():
	if selectedMap == maxMap: selectedMap = 0
	else: selectedMap+=1
	refreshMap()

func refreshMap():
	match selectedMap:
		0:mapName.text = "Arena0 (4p)"
		1:mapName.text = "Arena1 (8p)"
		2:mapName.text = "Arena2 (2p)"
