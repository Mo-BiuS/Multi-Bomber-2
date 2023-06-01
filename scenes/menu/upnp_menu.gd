extends HBoxContainer

const PORT:int = 9999
@onready var ipAdress = $upnpMenu/MarginContainer/ipAdress
@onready var button = $Button

func _process(delta):
	if(!multiplayer.get_unique_id() == 1):
		button.disabled = true

func _on_button_pressed():
	var upnp = UPNP.new()
	var discover_result = upnp.discover()
	
	assert(discover_result == UPNP.UPNP_RESULT_SUCCESS, "UPNP Discover Failed! Error %s" % discover_result)
	assert(upnp.get_gateway() and upnp.get_gateway().is_valid_gateway(), "UPNP Invalid Gateway!")
	
	var map_result = upnp.add_port_mapping(PORT)

	assert(map_result == UPNP.UPNP_RESULT_SUCCESS, "UPNP port mapping failed! Error %s" % map_result)
	ipAdress.text = upnp.query_external_address()
	button.disabled = true
