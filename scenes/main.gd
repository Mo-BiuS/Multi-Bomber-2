extends Node

@onready var connect = $connect
@onready var lobby = $lobby

const PORT:int = 9999
var enet_peer:ENetMultiplayerPeer = ENetMultiplayerPeer.new()
var nameDict:Dictionary

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
	connect.hide()
	lobby.show()

func removePlayer(id:int):
	nameDict.erase(id)

@rpc("any_peer") func addPlayer(id:int, str:String):
	if(multiplayer.get_unique_id() == 1):
		nameDict[id] = str
		lobby.addPlayer(id,str)
