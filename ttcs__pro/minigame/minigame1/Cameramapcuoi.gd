extends Camera2D
var velocity10 = Vector2(0,0)
var target_player = null

func _ready() -> void:
	target_player = Global.player_master

func _process(delta: float) -> void  :
	if Global.player_master != null:
		#chua loi mu loa
		if Global.alive_players.size() >= 1:
			global_position = lerp(global_position, Global.player_master.global_position, delta * 10)
		else:
			global_position =Vector2(0,0)
		#	get_tree().change_scene("res://Network_setup.tscn")
	else:
		if Global.alive_players.size() >= 1:
			if target_player == null:
				target_player = Global.alive_players[round(rand_range(0, Global.alive_players.size() - 1))]
			else:
				global_position = lerp(global_position, target_player.global_position, delta * 10)
