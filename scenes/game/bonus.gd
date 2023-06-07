extends Sprite2D

var bonusType
#0 bomb
#1 power
#2 speed

func init():
	var type = randi()%100
	if type < 15 : bonusType = 0
	if type < 65 : bonusType = 1
	else: bonusType = 2
	
	region_rect = Rect2i(64,bonusType*32,32,32)


func _on_area_2d_body_entered(body):
	if multiplayer.get_unique_id() == 1:
		if body.has_method("collide") :
			match bonusType:
				0:body.maxBomb+=1
				1:body.power+=1
				2:body.speed+=0.25
			queue_free()
