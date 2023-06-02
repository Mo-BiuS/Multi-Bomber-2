extends Node2D

@onready var playerList = $playerList

const playerModel = preload("res://scenes/game/player.tscn")

var state:int = 0
var mapId:int = 0
var startBomb:int = 1
var startSpeed:float = 1.0
var startPower:int = 1

func startGame():
	setState(1)

func addPlayer(id:int,playerName:String, headId:int, bodyId:int):
	rpc("addPlayerSync",id,playerName,headId,bodyId)
@rpc("authority","call_local")func addPlayerSync(id:int,playerName:String, headId:int, bodyId:int):
	var p = playerModel.instantiate()
	p.playerId = id
	p.playerName = playerName
	p.headId = headId
	p.bodyId = bodyId
	p.position = Vector2i(randi()%100, randi()%100)
	playerList.add_child(p,true)

func setState(value:int):
	state = value
	match state:
		0:pass
		1:pass
		2:pass
