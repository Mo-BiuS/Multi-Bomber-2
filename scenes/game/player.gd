extends CharacterBody2D

var headId:int = 0
var bodyId:int = 0
var playerName:String = "DEFAULT"
var playerId:int = 0

var boundaries:Rect2i = Rect2i(0,0,0,0)

var init:bool = false
var destination:Vector2
@export var speed:float = 1.0
@export var bomb:int = 0
@export var maxBomb:int = 1
@export var power:int = 1

@export var moving:int = -1

const IDLE=-1
const UP=0
const DOWN=1
const RIGHT=2
const LEFT=3

var isAlive:bool = true

@onready var head:AnimatedSprite2D = $head
@onready var body:AnimatedSprite2D = $body
@onready var camera:Camera2D = $camera
@onready var nameLabel:Label = $name/name
@onready var rayCast:RayCast2D = $RayCast2D
@onready var hud:CanvasLayer = $hud

@onready var speedLabel = $hud/PanelContainer/MarginContainer/VBoxContainer/speed
@onready var bombLabel = $hud/PanelContainer/MarginContainer/VBoxContainer/bomb
@onready var powerLabel = $hud/PanelContainer/MarginContainer/VBoxContainer/power

signal placeBombAt(id:int, pos:Vector2)

func _ready():
	camera.enabled = multiplayer.get_unique_id() == playerId
	initAnim()
	nameLabel.text = playerName
	destination = position
	if(multiplayer.get_unique_id() != playerId):
		hud.hide()
#===============================================================================

func _process(delta):
	if(multiplayer.get_unique_id() == playerId):
		speedLabel.text = "Speed : "+str(speed)
		bombLabel.text = "Bombs : "+str(bomb)+"/"+str(maxBomb)
		powerLabel.text = "Power : "+str(power)
	if(multiplayer.get_unique_id() == 1):
		if destination == position:
			match moving:
				UP: 
					if !collide(UP):
						destination+=Vector2(0,-64)
						playAnim("up")
				DOWN: 
					if !collide(DOWN):
						destination+=Vector2(0,64)
						playAnim("down")
				RIGHT: 
					if !collide(RIGHT):
						destination+=Vector2(64,0)
						playAnim("right")
				LEFT:
					if !collide(LEFT):
						destination+=Vector2(-64,0)
						playAnim("left")
		if destination != position:
			if destination.x == position.x:
				if destination.y < position.y:
					if destination.y < position.y-speed:
						position.y-=speed
					else:
						if moving == UP && !collide(UP):
							position.y-=speed
							destination+=Vector2(0,-64)
						else:
							position = destination
							stopAnim()
				else:
					if destination.y > position.y+speed:
						position.y+=speed
					else:
						if moving == DOWN && !collide(DOWN):
							position.y+=speed
							destination+=Vector2(0,64)
						else:
							position = destination
							stopAnim()
			else:
				if destination.x < position.x:
					if destination.x < position.x-speed:
						position.x-=speed
					else:
						if moving == LEFT && !collide(LEFT):
							position.x-=speed
							destination+=Vector2(-64,0)
						else:
							position = destination
							stopAnim()
				else:
					if destination.x > position.x+speed:
						position.x+=speed
					else:
						if moving == RIGHT && !collide(RIGHT):
							position.x+=speed
							destination+=Vector2(64,0)
						else:
							position = destination
							stopAnim()

func _input(event):
	if(playerId == multiplayer.get_unique_id()):
		if event.is_action_pressed("up"):
			rpc_id(1,"goUp")
		elif event.is_action_pressed("down"):
			rpc_id(1,"goDown")
		elif event.is_action_pressed("right"):
			rpc_id(1,"goRight")
		elif event.is_action_pressed("left"):
			rpc_id(1,"goLeft")
		elif event.is_action_released("up") && moving == UP:
			rpc_id(1,"idle")
		elif event.is_action_released("down") && moving == DOWN:
			rpc_id(1,"idle")
		elif event.is_action_released("right") && moving == RIGHT:
			rpc_id(1,"idle")
		elif event.is_action_released("left") && moving == LEFT:
			rpc_id(1,"idle")
		if event.is_action_pressed("bomb"):
			rpc_id(1,"placeBombAtSync")

@rpc("call_local","any_peer") func goUp():
	moving = UP
@rpc("call_local","any_peer") func goDown(): 
	moving = DOWN
@rpc("call_local","any_peer") func goRight(): 
	moving = RIGHT
@rpc("call_local","any_peer") func goLeft(): 
	moving = LEFT
@rpc("call_local","any_peer") func idle(): moving = IDLE
@rpc("call_local","any_peer") func placeBombAtSync(): placeBombAt.emit(playerId,position)

func collide(dir:int)->bool:
	if isAlive: 
		match dir :
			UP:rayCast.target_position = Vector2(0,-64)
			DOWN:rayCast.target_position = Vector2(0,64)
			LEFT:rayCast.target_position = Vector2(-64,0)
			RIGHT:rayCast.target_position = Vector2(64,0)
		rayCast.force_raycast_update()
		return rayCast.is_colliding()
	else :
		match dir : 
			UP:return !(int((position.y)/64) > int(boundaries.position.y))
			DOWN:return !(int((position.y+64)/64) < int(boundaries.size.y))
			LEFT:return !(int((position.x)/64) > int(boundaries.position.x))
			RIGHT:return !(int((position.x+64)/64) < int(boundaries.size.x))
		return false

#===============================================================================

func setDeath():
	isAlive = false
	self.hide()
	hud.hide()
	$CollisionShape2D.disabled = true
	speed = 6.0

func stopAnim():
	head.stop()
	body.stop()
func playAnim(animName:String):
	head.play(animName)
	body.play(animName)

func setPosition(pos:Vector2):
	position = pos
	destination = pos

func initAnim():
	head.sprite_frames = SpriteFrames.new()
	head.sprite_frames.add_animation("down")
	head.sprite_frames.add_animation("up")
	head.sprite_frames.add_animation("right")
	head.sprite_frames.add_animation("left")
	head.sprite_frames.add_frame("down", get_head(headId,0))
	head.sprite_frames.add_frame("up", get_head(headId,1))
	head.sprite_frames.add_frame("right", get_head(headId,2))
	head.sprite_frames.add_frame("left", get_head(headId,3))
	
	body.sprite_frames = SpriteFrames.new()
	body.sprite_frames.add_animation("down")
	body.sprite_frames.add_animation("up")
	body.sprite_frames.add_animation("right")
	body.sprite_frames.add_animation("left")
	for x in range(4):
		body.sprite_frames.add_frame("down", get_Body(bodyId,x,0))
		body.sprite_frames.add_frame("up", get_Body(bodyId,x,1))
		body.sprite_frames.add_frame("right", get_Body(bodyId,x,2))
		body.sprite_frames.add_frame("left", get_Body(bodyId,x,3))
	playAnim("down")
	stopAnim()

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



