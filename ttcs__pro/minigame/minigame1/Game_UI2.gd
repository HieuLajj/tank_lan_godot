extends CanvasLayer

onready var win_timer = $Control/Winner/Win_timer
onready var winner = $Control/Winner
#var go= ""
func _ready() -> void:
	winner.hide()

func _process(_delta: float) -> void:
	pass
	if Global.alive_players.size() <=1 and get_tree().has_network_peer():
	#	if go == "laivanhieu":
	
		if Global.alive_players[0].name == str(get_tree().get_network_unique_id()):
		#if mm ==5:
			winner.show()
			if $winnermusic.playing==false:
				$winnermusic.play()
	#		go = ""
		
		if win_timer.time_left <=0:
			win_timer.start()
	if Tonghop.kiemtraminigame==2:
		
		Tonghop.kiemtraminigame=1
		winner.show()
		if $winnermusic.playing==false:
			$winnermusic.play()
		if win_timer.time_left <=0:
			win_timer.start()
	#		go = ""
		
	


func _on_ngoc_body_entered(body):
	#if body.is_in_group("nguoichoi"):
	#	winner.show()
	#	if $winnermusic.playing==false:
	#		$winnermusic.play()
	#		
		
	#	if win_timer.time_left <=0:
	#		win_timer.start()
	pass


func _on_ngoc3_body_entered(body):
	#if body.is_in_group("nguoichoi"):
	#	winner.show()
		#if $winnermusic.playing==false:
	#		$winnermusic.play()
				
	#	if win_timer.time_left <=0:
	#		win_timer.start()
	pass
