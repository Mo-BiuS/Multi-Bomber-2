extends PanelContainer

@onready var playerTagContener:GridContainer = $MarginContainer/VBoxContainer/HBoxContainer/PanelContainer/MarginContainer/GridContainer

var playerTag = preload("res://scenes/menu/player_tag.tscn")

func addPlayer(id:int, playerName:String):
		var tag = playerTag.instantiate()
		tag.setPlayerName(playerName)
		tag.setId(id)
		playerTagContener.add_child(tag,true)
		
	
