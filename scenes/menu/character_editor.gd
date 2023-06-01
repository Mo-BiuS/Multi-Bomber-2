extends VBoxContainer

@onready var spriteHead:Sprite2D = $PanelContainer3/head
@onready var spriteBody:Sprite2D = $PanelContainer3/body

var headDict:Dictionary
var bodyDict:Dictionary
var headId:int = 1
var bodyId:int = 1

signal bodyChanged(id:int)
signal headChanged(id:int)

func _ready():
	headDict[1] = preload("res://ressources/player/head/head1.png")
	headDict[2] = preload("res://ressources/player/head/head2.png")
	headDict[3] = preload("res://ressources/player/head/head3.png")
	headDict[4] = preload("res://ressources/player/head/head4.png")
	
	bodyDict[1] = preload("res://ressources/player/body/body1.png")
	bodyDict[2] = preload("res://ressources/player/body/body2.png")
	bodyDict[3] = preload("res://ressources/player/body/body3.png")
	bodyDict[4] = preload("res://ressources/player/body/body4.png")

func _process(delta):
	spriteHead.set_texture(headDict[headId])
	spriteBody.set_texture(bodyDict[bodyId])

func _on_prev_head_pressed():
	if headId == 1: headId = 4
	else: headId-=1
	emit_signal("headChanged", headId)
func _on_next_head_pressed():
	if headId == 4: headId = 1
	else: headId+=1.
	emit_signal("headChanged", headId)

func _on_prev_body_pressed():
	if bodyId == 1: bodyId = 4
	else: bodyId-=1
	emit_signal("bodyChanged", bodyId)
func _on_next_body_pressed():
	if bodyId == 4: bodyId = 1
	else: bodyId+=1.
	emit_signal("bodyChanged", bodyId)
