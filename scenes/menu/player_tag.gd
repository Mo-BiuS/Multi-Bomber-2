extends PanelContainer

@onready var playerNameLabel:Label = $MarginContainer/VBoxContainer/PanelContainer2/playerName
@onready var head:Sprite2D = $MarginContainer/VBoxContainer/PanelContainer/head
@onready var body:Sprite2D = $MarginContainer/VBoxContainer/PanelContainer/body

var headDict:Dictionary
var bodyDict:Dictionary
var playerName:String
var id:int
@export var headId:int = 0
@export var bodyId:int = 0

func _ready():
	headDict[0] = preload("res://ressources/player/head/head1.png")
	headDict[1] = preload("res://ressources/player/head/head2.png")
	headDict[2] = preload("res://ressources/player/head/head3.png")
	headDict[3] = preload("res://ressources/player/head/head4.png")
	
	bodyDict[0] = preload("res://ressources/player/body/body1.png")
	bodyDict[1] = preload("res://ressources/player/body/body2.png")
	bodyDict[2] = preload("res://ressources/player/body/body3.png")
	bodyDict[3] = preload("res://ressources/player/body/body4.png")
	
	playerNameLabel.text = playerName

func _process(delta):
	head.set_texture(headDict[headId])
	body.set_texture(bodyDict[bodyId])

func setPlayerName(str:String):
	self.playerName = str
func setId(id:int):
	self.id = id
func setHead(id:int):
	if(id >= 0 && id <= 3):
		headId = id
func setBody(id:int):
	if(id >= 0 && id <= 3):
		bodyId = id
