extends CanvasLayer

@onready var playerTagContener:GridContainer = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/PanelContainer/MarginContainer/GridContainer
@onready var startButton:Button =$PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer2/PanelContainer/MarginContainer/VBoxContainer/start

@onready var mapSelector =$PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer2/PanelContainer/MarginContainer/VBoxContainer/mapSelector
@onready var bonusSelector = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer2/PanelContainer/MarginContainer/VBoxContainer/startingBonus

var playerTag = preload("res://scenes/menu/player_tag.tscn")

signal startGame

func _ready():
	multiplayer.peer_disconnected.connect(removePlayer)

func _process(delta):
	if(!multiplayer.get_unique_id() == 1):
		startButton.disabled = true

func removePlayer(id:int):
	for i in playerTagContener.get_children():
		if i.id == id: i.queue_free()

func addPlayer(id:int, playerName:String):
		var tag = playerTag.instantiate()
		tag.setPlayerName(playerName)
		tag.setId(id)
		playerTagContener.add_child(tag,true)


func _on_character_editor_body_changed(id):
	rpc("bodyChanged", multiplayer.get_unique_id(), id)
func _on_character_editor_head_changed(id):
	rpc("headChanged", multiplayer.get_unique_id(), id)
	
@rpc("any_peer", "call_local") func headChanged(id:int, bodyId:int):
	if(multiplayer.get_unique_id() == 1):
		var tag = getTagById(id)
		tag.setHead(bodyId)
@rpc("any_peer", "call_local") func bodyChanged(id:int, bodyId:int):
	if(multiplayer.get_unique_id() == 1):
		var tag = getTagById(id)
		tag.setBody(bodyId)

func getTagById(id:int):
	for i in playerTagContener.get_children():
		if i.id == id:return i
	return null
	
func _on_start_pressed():
	if playerTagContener.get_child_count() <= mapCapacity():
		startGame.emit()

func mapCapacity()->int:
	match getMapId():
		0:return 4
		1:return 8
		2:return 2
		_:return 0

#=====================================================================================

func getMapId()->int: return mapSelector.getMapId()
func getStartingBomb()->int: return bonusSelector.getBomb()
func getStartingSpeed()->int: return bonusSelector.getSpeed()
func getStartingPower()->int: return bonusSelector.getPower()
func getPlayerHead(id:int)->int: return getTagById(id).headId
func getPlayerBody(id:int)->int: return getTagById(id).bodyId



