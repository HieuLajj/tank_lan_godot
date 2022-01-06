extends Node

export (float) var broadcast_interval =1.0

var server_info = {"name": "LAN GAME"}

var socket_udp
var broadcast_timer = Timer.new()

var broadcast_port = Network.DEFAULT_PORT
func _ready():
	print("ocole")

func _enter_tree():
	print("google server_advertisier")
	broadcast_timer.wait_time = broadcast_interval
	broadcast_timer.one_shot = false
	broadcast_timer.autostart = true
	print("server advertiser")
	if get_tree().is_network_server():
		add_child(broadcast_timer)
		broadcast_timer.connect("timeout",self,"broadcast")	
		socket_udp = PacketPeerUDP.new()
		socket_udp.set_broadcast_enabled(true) # kich hoaot hoac vo hieu hoa viec gui cac goi tin, o day gui goi tin
		socket_udp.set_dest_address("255.255.255.255", broadcast_port) #Đặat địia chiỉ đich va cổong đeể guửi các goi va bien (dich, cong)
func broadcast():
	server_info.name = Network.current_player_username
	var packet_message = to_json(server_info)
	var packet = packet_message.to_ascii()
	socket_udp.put_packet(packet)         #gui goi tho

func _exit_tree():
	broadcast_timer.stop()
	if socket_udp != null:
		socket_udp.close()
