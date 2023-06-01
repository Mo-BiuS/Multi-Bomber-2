extends PanelContainer

@onready var playerName:LineEdit = $MarginContainer/VBoxContainer/PanelContainer2/MarginContainer/VBoxContainer/HBoxContainer/name
@onready var ip:LineEdit = $MarginContainer/VBoxContainer/PanelContainer2/MarginContainer/VBoxContainer/HBoxContainer2/ip

signal createServer(n:String)
signal createClient(n:String,ip:String)



func _on_join_pressed():
	if !playerName.text.is_empty() && ip.text.is_valid_ip_address(): 
		createClient.emit(playerName.text, ip.text)
func _on_host_pressed():
	if !playerName.text.is_empty(): 
		createServer.emit(playerName.text)
