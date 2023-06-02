extends TileMap

func getPos()->Array[Vector2]:
	var a:Array[Vector2]
	for i in get_children():
		a.append(i.position)
	return a
