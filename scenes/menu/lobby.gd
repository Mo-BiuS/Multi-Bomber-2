extends PanelContainer

@onready var playerTagContener:GridContainer = $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/PanelContainer/MarginContainer/GridContainer
@onready var startButton:Button = $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer2/PanelContainer2/MarginContainer/VBoxContainer/start

@onready var mapSelector = $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer2/PanelContainer2/MarginContainer/VBoxContainer/mapSelector
@onready var bonusSelector = $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer2/PanelContainer2/MarginContainer/VBoxContainer/startingBonus 

var playerTag = preload("res://scenes/menu/player_tag.tscn")

signal startGame

func _process(delta):
	if(!multiplayer.get_unique_id() == 1):
		startButton.disabled = true

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
	startGame.emit()
	
#=====================================================================================

func getMapId()->int: return mapSelector.getMapId()
func getStartingBomb()->int: return bonusSelector.getBomb()
func getStartingSpeed()->int: return bonusSelector.getSpeed()
func getStartingPower()->int: return bonusSelector.getPower()
func getPlayerHead(id:int)->int: return getTagById(id).headId
func getPlayerBody(id:int)->int: return getTagById(id).bodyId



