extends Node2D

@onready var playerList = $playerList
@onready var arenaHolder = $arenaHolder

const playerModel = preload("res://scenes/game/player.tscn")

const arena0 = preload("res://scenes/game/arena/arena_0.tscn")

var state:int = 0
var mapId:int = 0
var startBomb:int = 1
var startSpeed:float = 1.0
var startPower:int = 1

func startGame():
	rpc("loadMap", mapId)
	placePlayer()
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

@rpc("authority","call_local")func loadMap(id:int):
	for i in arenaHolder.get_children():
		i.queue_free()
	var map
	match id :
		0:map = arena0.instantiate()
	arenaHolder.add_child(map, true)

func placePlayer():
	var positions:Array[Vector2] = arenaHolder.get_children()[0].getPos()
	for i in playerList.get_children():
		var pos = positions.pick_random()
		positions.erase(pos)
		i.position = pos*2
