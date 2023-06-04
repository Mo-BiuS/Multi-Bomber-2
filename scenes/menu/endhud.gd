extends CanvasLayer

signal restart
signal menu

@onready var winnerLabel = $PanelContainer/MarginContainer/VBoxContainer/PanelContainer/MarginContainer/winnerLabel
@onready var board:GridContainer = $PanelContainer/MarginContainer/VBoxContainer/PanelContainer2/MarginContainer/board
@onready var replayButton = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/replayButton
@onready var menuButton = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/menuButton
var dict:Dictionary

func _process(delta):
	var dis = multiplayer.get_unique_id() != 1
	replayButton.disabled = dis
	menuButton.disabled = dis

func addPlayer(str:String):
	rpc("addPlayerSync", str)
func removePlayer(str:String):
	rpc("removePlayerSync", str)
func setWinner(str:String):
	rpc("setWinnerSync",str)
func setDraw():
	rpc("setDrawSync")

@rpc("authority","call_local") func addPlayerSync(str:String):
	dict[str] = 0
	var nameLabel:Label = Label.new()
	nameLabel.text = str
	var scoreLabel:Label = Label.new()
	scoreLabel.text = str(0)
	board.add_child(nameLabel,true)
	board.add_child(scoreLabel,true)

@rpc("authority","call_local") func removePlayerSync(str:String):
	dict.erase(str)
	var found = false
	for i in board.get_children():
		if found :
			i.queue_free()
			found = false
		if i.text == str:
			i.queue_free()
			found = true

@rpc("authority","call_local") func setWinnerSync(str:String):
	winnerLabel.text = "Winner : " + str
	dict[str]+=1
	var found = false
	for i in board.get_children():
		if found :
			i.text = str(dict[str])
			found = false
		if i.text == str:
			found = true

@rpc("authority", "call_local") func setDrawSync():
	winnerLabel.text = "Draw !"

func _on_replay_button_pressed():
	restart.emit()
	
func _on_menu_button_pressed():
	menu.emit()
