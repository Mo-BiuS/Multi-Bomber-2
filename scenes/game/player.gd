extends CharacterBody2D

@export var headId:int = 0
@export var bodyId:int = 0
@export var playerName:String = "DEFAULT"
@export var playerId:int = 0

var init = false

@onready var head:AnimatedSprite2D = $head
@onready var body:AnimatedSprite2D = $body
@onready var camera:Camera2D = $camera
@onready var nameLabel:Label = $name/name

func _ready():
	camera.enabled = multiplayer.get_unique_id() == playerId
	initAnim()
	nameLabel.text = playerName

#===============================================================================

func stopAnim(animName:String):
	head.stop()
	body.stop()
func playAnim(animName:String):
	head.play(animName)
	body.play(animName)

func initAnim():
	head.sprite_frames.add_frame("down", get_head(headId,0))
	head.sprite_frames.add_frame("up", get_head(headId,1))
	head.sprite_frames.add_frame("right", get_head(headId,2))
	head.sprite_frames.add_frame("left", get_head(headId,3))
	for x in range(4):
		body.sprite_frames.add_frame("down", get_Body(bodyId,x,0))
		body.sprite_frames.add_frame("up", get_Body(bodyId,x,1))
		body.sprite_frames.add_frame("right", get_Body(bodyId,x,2))
		body.sprite_frames.add_frame("left", get_Body(bodyId,x,3))
	head.play("down")
	head.stop()
	body.play("down")
	body.stop()

func get_head(id:int, y:int) -> AtlasTexture:
	var headTexture:Texture2D = load("res://ressources/player/head/head"+str(id+1)+".png")
	var atlas_texture := AtlasTexture.new()
	atlas_texture.set_atlas(headTexture)
	atlas_texture.set_region(Rect2(0,y*16,16,16))
	return atlas_texture
func get_Body(id:int, x:int, y:int) -> AtlasTexture:
	var bodyTexture:Texture2D = load("res://ressources/player/body/body"+str(id+1)+".png")
	var atlas_texture := AtlasTexture.new()
	atlas_texture.set_atlas(bodyTexture)
	atlas_texture.set_region(Rect2(x*16,y*16,16,16))
	return atlas_texture



