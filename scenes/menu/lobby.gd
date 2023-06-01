extends PanelContainer

@onready var playerTagContener:GridContainer = $MarginContainer/VBoxContainer/HBoxContainer/PanelContainer/MarginContainer/GridContainer

var playerTag = preload("res://scenes/menu/player_tag.tscn")

func addPlayer(id:int, playerName:String):
		var tag = playerTag.instantiate()
		tag.setPlayerName(playerName)
		tag.setId(id)
		playerTagContener.add_child(tag,true)



func _on_character_editor_body_changed(id):
	rpc("bodyChanged", multiplayer.get_unique_id(), id)
@rpc("any_peer", "call_local") func bodyChanged(id:int, bodyId:int):
	if(multiplayer.get_unique_id() == 1):
		var tag = getTagById(id)
		tag.setBody(bodyId)
func _on_character_editor_head_changed(id):
	rpc("headChanged", multiplayer.get_unique_id(), id)
@rpc("any_peer", "call_local") func headChanged(id:int, bodyId:int):
	if(multiplayer.get_unique_id() == 1):
		var tag = getTagById(id)
		tag.setHead(bodyId)
func getTagById(id:int):
	for i in playerTagContener.get_children():
		if i.id == id:return i
	return null
