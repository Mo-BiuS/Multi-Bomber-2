extends Node

const connect_menu = preload("res://scenes/menu/connect_menu.tscn")

var status:int = 0

func _ready():
	refresh_child()

func _process(delta):
	pass

func refresh_child():
	for i in get_children():
		i.queue_free()

	match status:
		0:
			var cm=connect_menu.instantiate()
			add_child(cm, true)
