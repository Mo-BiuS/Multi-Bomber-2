extends CharacterBody2D

var timer:float = 3.0
var playerId:int = 0
var power:int

@onready var texture = $Sprite2D

signal explosionAt(id:int, pos:Vector2)

func _process(delta):
	timer-=delta
	if(timer > 2.0):texture.region_rect=Rect2(32,64,32,32)
	elif(timer > 1.0):texture.region_rect=Rect2(32,32,32,32)
	elif(timer > 0.0):texture.region_rect=Rect2(32,0,32,32)
	else:detonate()

func detonate():
	if multiplayer.get_unique_id() == 1 : 
		explosionAt.emit(playerId, position, power)
		queue_free()
