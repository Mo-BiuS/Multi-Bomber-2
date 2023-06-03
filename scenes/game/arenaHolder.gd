extends Node2D

const explosionTime = 1.0
var explosionDict:Dictionary

signal spawnBonusAt(pos:Vector2i)

func _process(delta):
	if get_child_count() > 0:
		var arena:TileMap = get_children()[0]
		for i in explosionDict.keys():
			explosionDict[i]-=delta
			if explosionDict[i] <= 0:
				arena.set_cells_terrain_connect(3,[i],0,0)
				explosionDict.erase(i)

func explosionAt(pos:Vector2i, power:int):
	rpc("explosionAtSync",pos,power)

@rpc("call_local") func explosionAtSync(pos:Vector2i, power:int):
	var arena:TileMap = get_children()[0]
	var a = calcExplosion(pos, power,0)
	for i in a:
		explosionDict[i] = 1.0
	arena.set_cells_terrain_connect(3,a,2,0)

func calcExplosion(pos:Vector2i, power:int, direction:int)->Array[Vector2i]:
	var a:Array[Vector2i] = []
	var arena:TileMap = get_children()[0]
	if( arena.get_cell_source_id(1, pos) == -1):
		a.append(pos)
		if(power >= 0 && arena.get_cell_source_id(2, pos) == -1):
			if direction == 0 || direction == 1 : a.append_array(calcExplosion(pos+Vector2i(1,0),power-1,1))
			if direction == 0 || direction == 2 : a.append_array(calcExplosion(pos+Vector2i(0,1),power-1,2))
			if direction == 0 || direction == 3 : a.append_array(calcExplosion(pos+Vector2i(-1,0),power-1,3))
			if direction == 0 || direction == 4 : a.append_array(calcExplosion(pos+Vector2i(0,-1),power-1,4))
		if multiplayer.get_unique_id() == 1 && arena.get_cell_atlas_coords(2, pos) == Vector2i(0,0):spawnBonusAt.emit(pos)
		arena.set_cells_terrain_connect(2,[pos],0,0)
	return a
