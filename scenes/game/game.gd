extends Node2D

@onready var playerList = $playerList
@onready var bombList = $bombList
@onready var bonusList = $bonusList
@onready var arenaHolder = $arenaHolder
@onready var endhud = $endhud

const playerModel = preload("res://scenes/game/player.tscn")
const bombModel = preload("res://scenes/game/bomb.tscn")
const bonusModel = preload("res://scenes/game/bonus.tscn")

const arena0 = preload("res://scenes/game/arena/arena_0.tscn")

var state:int = 0
var mapId:int = 0
var startBomb:int = 1
var startSpeed:float = 1.0
var startPower:int = 1

func _process(delta):
	if(multiplayer.get_unique_id() == 1 && state == 1):
		var someoneDied = false
		for i in playerList.get_children():
			if i.isAlive && arenaHolder.isExplosed(i.position/64):
				i.setDeath()
				someoneDied = true
		if(someoneDied && alivePlayer() <= 1):setState(2)

func addPlayer(id:int,playerName:String, headId:int, bodyId:int):
	rpc("addPlayerSync",id,playerName,headId,bodyId)
	endhud.addPlayer(playerName)
@rpc("authority","call_local")func addPlayerSync(id:int,playerName:String, headId:int, bodyId:int):
	var p = playerModel.instantiate()
	p.playerId = id
	p.playerName = playerName
	p.headId = headId
	p.bodyId = bodyId
	p.position = Vector2i(randi()%100, randi()%100)
	playerList.add_child(p,true)
	if multiplayer.get_unique_id() == 1:
		p.placeBombAt.connect(placeBombAt)

func placeBombAt(id:int, pos:Vector2):
	var player = getPlayerById(id)
	if player != null && player.maxBomb > player.bomb:
		var canPlace:bool = true
		for i in bombList.get_children():
			canPlace = canPlace && !(Vector2i(i.position/64) == Vector2i(pos/64))
		if canPlace:
			var bomb = bombModel.instantiate()
			bomb.position = Vector2i((pos)/64)*64+Vector2i(32,32)
			bombList.add_child(bomb, true)
			bomb.playerId = player.playerId
			bomb.power = player.power
			bomb.explosionAt.connect(explosionAt)
			player.bomb+=1

func explosionAt(id:int, pos:Vector2, power:int):
	var player = getPlayerById(id)
	if player != null :
		player.bomb-=1
	arenaHolder.explosionAt(Vector2i(pos/64), power)

func getPlayerById(id:int):
	for i in playerList.get_children():
		if i.playerId == id: return i
	return null

func setState(value:int):
	state = value
	match state:
		0:pass
		1:
			endhud.hide()
			rpc("loadMap", mapId)
			for i in playerList.get_children():
				i.maxBomb = startBomb
				i.speed = startSpeed
				i.power = startPower
				i.setAlive()
				i.boundaries = arenaHolder.get_children()[0].size
			placePlayer()
		2:
			setWinner()
			for i in bonusList.get_children():
				i.queue_free()
			for i in bombList.get_children():
				i.queue_free()
			for i in playerList.get_children():
				i.setDeath()
				i.setDisabled()
			endhud.show()

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
		i.setPosition(pos*2)

func _on_arena_holder_spawn_bonus_at(pos):
	var bonus = bonusModel.instantiate()
	bonus.init()
	bonus.position = pos*64+Vector2i(32,32)
	bonusList.add_child(bonus, true)
	
func alivePlayer()->int:
	var count:int = 0
	for p in playerList.get_children():
		if p.isAlive : count+=1
	return count

func setWinner():
	var found = false
	for p in playerList.get_children():
		if p.isAlive : 
			endhud.setWinner(p.playerName)
			found = true
	if !found : endhud.setDraw()
	

func _on_endhud_restart():
	setState(1)
