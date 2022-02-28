extends Node

const DEFAULT_PORT = 28960
const MAX_CLIENTS = 6
var server = null
var client = null

var ip_address = ""
var current_player_username = ""

var networked_object_name_index = 0 setget networked_object_name_index_set
puppet var puppet_networked_object_name_index = 0 setget puppet_networked_object_name_index_set
func _ready() ->void:
	
	if OS.get_name() =="Windows":
		ip_address = IP.get_local_addresses()[3]
	elif OS.get_name() == "Android":
		ip_address = IP.get_local_addresses()[0]
	else:
		ip_address = IP.get_local_addresses()[3]
	print(ip_address)

	for ip in IP.get_local_addresses():
		if ip.begins_with("192.168.") and not ip.ends_with(".1"):
			ip_address = ip
	get_tree().connect("connected_to_server",self,"_connected_to_server")
	get_tree().connect("server_disconnected",self,"_server_disconnected")
	get_tree().connect("connection_failed",self,"_connection_failed")

func create_server() -> void:
	server = NetworkedMultiplayerENet.new()
	if server.get_connection_status() != server.CONNECTION_DISCONNECTED:
		server.close_connection(1)
	server.create_server(DEFAULT_PORT,MAX_CLIENTS)
	#fix
	get_tree().set_network_peer(null)
	
	get_tree().set_network_peer(server)
	Global.instance_node(load("res://Server_advertiser.tscn"), get_tree().current_scene)
	
func join_server() -> void:
	client =  NetworkedMultiplayerENet.new()
	client.create_client(ip_address, DEFAULT_PORT)
	get_tree().set_network_peer(client)
	
func reset_network_connection() -> void:
	if get_tree().has_network_peer():
		get_tree().network_peer = null

func disconnect_server() -> void:
	#get_tree().network_peer = null
	#get_tree().get_network_unique_id()
	if get_tree().is_network_server():
		server.close_connection(1)
	_player_disconnected2(get_tree().get_network_unique_id())
	for child in Persistent_nodes.get_children():
		if child.is_in_group("Net"):
			child.queue_free()
	get_tree().network_peer = null
	reset_network_connection()
func _connected_to_server() -> void:
	print("ket noi thanh cong")
func _server_disconnected() -> void:
	#if get_tree().is_network_server():
	
	for child in Persistent_nodes.get_children():
		if child.is_in_group("Net"):
			child.queue_free()
			
	reset_network_connection()
	
	if Global.ui != null:
		print("ket noi khong thanh cong")
		var prompt = Global.instance_node(load("res://Simple_prompt.tscn"), Global.ui)
		prompt.set_text("Khong the ket noi duoc voi server")
	
func _connection_failed():
	for child in Persistent_nodes.get_children():
		if child.is_in_group("Net"):
			child.queue_free()
			
	reset_network_connection()
	if Global.ui != null:
		var prompt = Global.instance_node(load("res://Simple_prompt.tscn"), Global.ui)
		prompt.set_text("Ket noi bi loi")
	
func puppet_networked_object_name_index_set(new_value):
	networked_object_name_index = new_value
func networked_object_name_index_set(new_value):
	networked_object_name_index = new_value
	if get_tree().is_network_server():
		rset("puppet_networked_object_name_index", networked_object_name_index)
		
func _player_disconnected2(id) -> void:
	if Persistent_nodes.has_node(str(id)):
		Persistent_nodes.get_node(str(id)).username_text_instance.queue_free()
		Persistent_nodes.get_node(str(id)).hp_instance.queue_free()
		Persistent_nodes.get_node(str(id)).queue_free()
	for child in Persistent_nodes.get_children():
		if child.is_in_group("Net"):
			child.queue_free()
			
	reset_network_connection()
func refresh():
	for ip in IP.get_local_addresses():
		if ip.begins_with("192.168.") and not ip.ends_with(".1"):
			ip_address = ip

