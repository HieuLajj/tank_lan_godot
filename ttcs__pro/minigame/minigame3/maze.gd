extends Node2D

var current_spawn_location_instance_number =1
var current_player_for_spawn_location_number = null

func _ready() -> void:
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	
	if get_tree().is_network_server():
		setup_players_positions()
		Tonghop.nhanvatset("map1")
	for player in Persistent_nodes.get_children():
		if player.is_in_group("Player"):
			player.set_rotation(0)
#func _process(delta):
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
					
					#$Sprite.hide()
					#$ninja.show()
func _player_disconnected(id) -> void:
	if Persistent_nodes.has_node(str(id)):
		Persistent_nodes.get_node(str(id)).username_text_instance.queue_free()
		Persistent_nodes.get_node(str(id)).queue_free()
		


func _on_ngoc_body_entered(body):
	pass # Replace with function body.
