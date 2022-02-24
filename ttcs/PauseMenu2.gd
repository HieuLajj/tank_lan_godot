extends Control

func _on_Resumebutton_pressed():
	get_tree().reload_current_scene()
#	get_tree().change_scene("res://Game.tscn")
#	get_tree().change_scene("res://Player.tscn")
#	for player in Persistent_nodes.get_children():
#		if player.is_in_group("Player"):
#			player.visible = true
	

func _on_Quitbutton_pressed():
	get_tree().quit()


func _on_giamamluong_pressed():
	print("an tat am luong")
	#$nood.play("res://music/round_end.ogg")
	#$game_music.autoplay = true
#	$game_music.play()
	#if $game_music.playing == true:
	#	$game_music.playing = false
	#	$game_music.stop()
	#print($game_music.autoplay)


func _on_tangamluong_pressed():
	$game_music.autoplay = false
	$game_music.stop()
