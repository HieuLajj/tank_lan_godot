extends Control

var player = load("res://Playerman/Player.tscn")

var current_spawn_location_instance_number =1
var current_player_for_spawn_location_number = null

onready var multiplayer_config_ui = $Multiplayer_configure
onready var username_text_edit = $Multiplayer_configure/Username_text_edit
onready var device_ip_address = $UI/Device_ip_address

onready var start_game = $UI/Start_game
var ten=null
var bienten =1
var tenthat
onready var audio = $audio
func _ready() -> void:
	#thiet lap tro ve map binh thuong
	Tonghop.nhanvatset("null")
	get_tree().connect("network_peer_connected",self,"_player_connected")
	get_tree().connect("network_peer_disconnected",self,"_player_disconnected")
	get_tree().connect("connected_to_server",self,"_connected_to_server")
	
	device_ip_address.text = Network.ip_address
	
	if get_tree().network_peer != null:
		multiplayer_config_ui.hide()
		
		for player in Persistent_nodes.get_children():
			if player.is_in_group("Player"):
				for spawn_location in $Spawn_locations.get_children():
					if int(spawn_location.name) == current_spawn_location_instance_number and current_player_for_spawn_location_number != player:
						player.rpc("update_position", spawn_location.global_position)
						player.rpc("enable")
						
						player.tankdohoa_set("3")
						
						current_spawn_location_instance_number +=1
						current_player_for_spawn_location_number = player
	else:
		start_game.hide()
		$chatbox.hide()
	Tonghop.kiemtramap=1
func _process(_delta: float) -> void:
	#device_ip_address.text = Network.ip_address
	ten = Tonghop.tennhanvat
	if get_tree().network_peer !=null:
		if get_tree().get_network_connected_peers().size() >=1 and get_tree().is_network_server():
			start_game.show()
			
		else:
			start_game.hide()
			
func _player_connected(id) -> void:
	print("Nguoi choi " +str(id)+ " da ket noi")
	instance_player(id)
func _player_disconnected(id) -> void:
	print("Nguoi choi "+ str(id)+ " da ngat ket noi")
	if Persistent_nodes.has_node(str(id)):
		Persistent_nodes.get_node(str(id)).username_text_instance.queue_free()
		Persistent_nodes.get_node(str(id)).hp_instance.queue_free()
		#hp_instance
		Persistent_nodes.get_node(str(id)).queue_free()

func _on_Create_server_pressed():
	audio.play()
	if username_text_edit.text !="":
		$chatbox.show()
		Network.current_player_username = username_text_edit.text
		multiplayer_config_ui.hide()
		Network.create_server()
		instance_player(get_tree().get_network_unique_id())


func _on_join_server_pressed():
	audio.play()
	if username_text_edit.text != "":
		$chatbox.show()
		multiplayer_config_ui.hide()
		username_text_edit.hide()
		Global.instance_node(load("res://Scene/Server_browser.tscn"),self)
		print("may dang o che do join");

func _connected_to_server() -> void:
	yield(get_tree().create_timer(0,1), "timeout") # delay ko 0.1 sau do moi thuc hien tiep
	instance_player(get_tree().get_network_unique_id())

func instance_player(id) -> void:
	var player_instance = Global.instance_node_at_location(player, Persistent_nodes, get_node("Spawn_locations/"+str(current_spawn_location_instance_number)).global_position)
	player_instance.name =str(id)
	player_instance.set_network_master(id)
	player_instance.username = username_text_edit.text
#	player_instance.mau = "fawe"
	#if player_instance.username.length()!=0:
	#	ten = player_instance.username
	current_spawn_location_instance_number +=1


func _on_Start_game_pressed():
	audio.play()
	rpc("switch_to_game")

sync func switch_to_game() -> void:
	for child in Persistent_nodes.get_children():
		if child.is_in_group("Player"):
		#	Tonghop.danbanset("danthuong")
			child.update_shoot_mode(true)
			pass
	get_tree().change_scene("res://bando/Game.tscn")

onready var message = $chatbox/text
onready var chat = $chatbox/posts

remote func post_message(email,comment):
#	if get_tree().has_network_peer():
	chat.text+= (str(email)+ ":: "+str(comment) +"\n")
#	print(str(email)+ ":: "+str(comment) +"\n")
	rpc_unreliable("share_name",ten)
	rpc_unreliable("share_message", message.text)
remote func share_name(id):
	id =ten
remote func share_message(_text_):
	_text_ = message.text


func _on_posttext_pressed():
	audio.play()
	if message.text.empty():
		return
	else:
		if message.text.length()!=0 and message.text.length() <=300:
			post_message(ten,message.text)
			rpc_unreliable("post_message",ten,message.text)
	while message.text.length()!= 0:
		message.delete_char_at_cursor()




func _on_Campaign_pressed():
	audio.play()
	get_tree().change_scene("res://gameoffline/Scene/Arena.tscn")

func _on_Button_pressed():
	audio.play()
	get_tree().change_scene("res://Scene/GUI.tscn")
	Network.disconnect_server()
	Network.refresh()
	device_ip_address.text = Network.ip_address


func _on_war_pressed():
	audio.play()
	get_tree().change_scene("res://gameoffline2/Scene/mainarmy.tscn")
