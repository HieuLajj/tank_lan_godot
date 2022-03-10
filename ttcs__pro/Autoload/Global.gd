extends Node

var player_master = null
var ui = null

var alive_players = []
var node_creation_parent = null
var player = null
var camera = null

var points = 0
var highscore = 0
#minigame2
var levels = []
var unlockedLevels = 1
var leveltronggame =1
var selected_gun =1
func instance_node_at_location(node: Object, parent: Object, location: Vector2) -> Object:
	var node_instance = instance_node(node, parent)
	node_instance.global_position = location
	return node_instance

func instance_node(node: Object, parent: Object) -> Object:
	var node_instance = node.instance()
	parent.add_child(node_instance)
	return node_instance


func instance_node_1(node, location, parent):
	var node_instance = node.instance()
	parent.add_child(node_instance)
	node_instance.global_position = location
	return node_instance

func save():
	var save_dict ={
		"highscore": highscore,
		"unlockedLevels": unlockedLevels
	}
	return save_dict
func save_game():
	var save_game = File.new()
	save_game.open_encrypted_with_pass("user://savegame.save",File.WRITE,"enc")
#	save_game.open("user://savegame.save",File.WRITE)
	save_game.store_line(to_json(save()))
	save_game.close()

func load_game():
	var save_game = File.new()
	if not save_game.file_exists("user://savegame.save"):
		print("co loi xay ra load file")
		return
	save_game.open_encrypted_with_pass("user://savegame.save",File.READ,"enc")
	#save_game.open("user://savegame.save",File.READ)
	var current_line = parse_json(save_game.get_line())
	highscore = current_line["highscore"]
	unlockedLevels = current_line["unlockedLevels"]
	save_game.close()
