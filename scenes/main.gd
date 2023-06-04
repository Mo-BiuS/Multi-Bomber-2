extends Node

@onready var connect = $connect
@onready var lobby = $lobby
@onready var game = $game

const PORT:int = 9999
var enet_peer:ENetMultiplayerPeer = ENetMultiplayerPeer.new()
var nameDict:Dictionary
var state:int = 0

func _ready():
	setState(0)

func _on_connect_create_client(n, ip):
	enet_peer.create_client(ip, PORT)
	multiplayer.multiplayer_peer = enet_peer
	await(multiplayer.connected_to_server)
	rpc("addPlayer", multiplayer.get_unique_id(), n)

func _on_connect_create_server(n):
	enet_peer.create_server(PORT)
	multiplayer.multiplayer_peer = enet_peer
	multiplayer.peer_disconnected.connect(removePlayer)
	nameDict[1] = n
	
	lobby.addPlayer(1,n)
	setState(1)

func setState(value:int):
	state = value
	match value:
		0:
			connect.show()
			lobby.hide()
			game.hide()
		1:
			connect.hide()
			lobby.show()
			game.hide()
		2:
			connect.hide()
			lobby.hide()
			game.show()

func removePlayer(id:int):
	nameDict.erase(id)

@rpc("any_peer") func addPlayer(id:int, str:String):
	if(multiplayer.get_unique_id() == 1):
		nameDict[id] = str
		lobby.addPlayer(id,str)


func _on_lobby_start_game():
	game.mapId = lobby.getMapId()
	game.startBomb = lobby.getStartingBomb()
	game.startSpeed = lobby.getStartingSpeed()
	game.startPower = lobby.getStartingPower()
	game.addPlayer(1,nameDict[1], lobby.getPlayerHead(1), lobby.getPlayerBody(1))
	for i in multiplayer.get_peers():
		game.addPlayer(i,nameDict[i], lobby.getPlayerHead(i), lobby.getPlayerBody(i))
	setState(2)
	game.setState(1)
