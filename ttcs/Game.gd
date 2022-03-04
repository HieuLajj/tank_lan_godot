extends Node2D

var current_spawn_location_instance_number =1
var current_player_for_spawn_location_number = null

func _ready() -> void:
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	
	if get_tree().is_network_server():
		setup_players_positions()
	
	if $chuyenmap.time_left <=0:
		$chuyenmap.start()
	if $baocaochuyenmap.time_left <=0:
		$baocaochuyenmap.start()
	Tonghop.kiemtramap=2
	$TileMap.use_parent_material = true
func _process(delta):
	if Input.is_action_just_pressed("chuyen"):
			rpc("switch_to_game")

	if Input.is_action_just_pressed("chuyen2"):
		rpc("switch_to_game2")
	if Input.is_action_just_pressed("chuyen3"):
		rpc("switch_to_game3")
	if Input.is_action_just_pressed("chuyen4"):
		rpc("switch_to_game4")
	if Input.is_action_just_pressed("chuyen5"):
		rpc("switch_to_game5")
	if Global.alive_players.size()<2:
		$vongtron.stop()
		
	
#	if Input.is_action_just_pressed("tankred"):
#		for player in Persistent_nodes.get_children():
#			if player.is_in_group("Player"):
#				player.visible = false
		#Global.instance_node(load("res://PauseMenu2.tscn"),self)
#		get_tree().change_scene("res://PauseMenu2.tscn")
func setup_players_positions() -> void:
	for player in Persistent_nodes.get_children():
		if player.is_in_group("Player"):
			for spawn_location in $Spawn_locations.get_children():
				if int(spawn_location.name) == current_spawn_location_instance_number and current_player_for_spawn_location_number != player:
					player.rpc("update_position", spawn_location.global_position)
					current_spawn_location_instance_number +=1
					current_player_for_spawn_location_number = player
func _player_disconnected(id) -> void:
	if Persistent_nodes.has_node(str(id)):
		Persistent_nodes.get_node(str(id)).username_text_instance.queue_free()
		Persistent_nodes.get_node(str(id)).queue_free()
		


func _on_SpawnTimer_timeout():
	if $hphoimaudong.visible ==false:
		$hphoimaudong.visible = true
	var area = $SpawnArea
	var position = area.rect_position + Vector2(randf() * area.rect_size.x,randf() * area.rect_size.y)
	$hphoimaudong.position = position


func _on_SpawnTimer2_timeout():
	var area2 = $SpawnArea2
	var position2 = area2.rect_position + Vector2(randf() * area2.rect_size.x,randf() * area2.rect_size.y)
	$tangtocdong.position = position2	
sync func switch_to_game() -> void:
	for child in Persistent_nodes.get_children():
		if child.is_in_group("Player"):
		#	Tonghop.danbanset("danthuong")
		#	child.update_shoot_mode(true)
			if child.visible:
				set_rotation(0)
				get_tree().change_scene("res://mapcuoigame.tscn")
	#set_rotation(0)
	#get_tree().change_scene("res://mapcuoigame.tscn")
sync func switch_to_game2() -> void:
	for child in Persistent_nodes.get_children():
		if child.is_in_group("Player"):
		#	Tonghop.danbanset("danthuong")
		#	child.update_shoot_mode(true)
			if child.visible:
				set_rotation(0)
				get_tree().change_scene("res://mapcuoi2.tscn")
sync func switch_to_game3() -> void:
	for child in Persistent_nodes.get_children():
		if child.is_in_group("Player"):
		#	Tonghop.danbanset("danthuong")
		#	child.update_shoot_mode(true)
			if child.visible:
				set_rotation(0)
				get_tree().change_scene("res://minigame/maze.tscn")
sync func switch_to_game4() -> void:
	for child in Persistent_nodes.get_children():
		if child.is_in_group("Player"):
		#	Tonghop.danbanset("danthuong")
		#	child.update_shoot_mode(true)
			if child.visible:
				set_rotation(0)
				get_tree().change_scene("res://minigame/bombminigame.tscn")
sync func switch_to_game5()-> void:
	$vongtron.play("mms")
func _on_chuyenmap_timeout():
	print("chuyenmap")
	pass
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var b = rng.randi_range(1,2)
##	if rng.randi_range(1,3)==1:
	if Global.alive_players.size()==4:
		rpc("switch_to_game5")
#	#	print("10s da troi qua roi em oi")
	if Global.alive_players.size()==3:
		if b==1:
			rpc("switch_to_game3")
		else:
			rpc("switch_to_game4")
	if Global.alive_players.size()==2:
	#	if b==1:
			rpc("switch_to_game")
	#	else:
	#		rpc("switch_to_game2")
	
	
#	#if get_tree(). get_network_connected_peers():
#	#	rpc("switch_to_game")


func _on_baocaochuyenmap_timeout():
	$TileMap.use_parent_material = false
	print("baocao")

