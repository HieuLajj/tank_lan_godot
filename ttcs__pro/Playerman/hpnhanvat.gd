extends Node2D


var player_following2 = null
var text2 ="" setget text_set2

onready var label2 = $Label2


func _process(_delta: float)-> void:
	if player_following2 != null and is_instance_valid(player_following2):
		global_position = player_following2.global_position

func text_set2(new_text2) -> void:
	text2 = new_text2
	if text2 == null:
		label2.text ="---"
	else:
		label2.text = text2


