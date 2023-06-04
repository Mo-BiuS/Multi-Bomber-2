extends TileMap


var size:Rect2i=Rect2i(1,1,28,28)

func getPos()->Array[Vector2]:
	var a:Array[Vector2]
	for i in get_children():
		a.append(i.position)
	return a
