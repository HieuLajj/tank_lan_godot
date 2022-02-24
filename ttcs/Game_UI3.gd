extends CanvasLayer

onready var win_timer = $Control/Winner/Win_timer
onready var winner = $Control/Winner
#var go= ""
func _ready() -> void:
	winner.hide()

func _process(_delta: float) -> void:
	if Global.alive_players.size() <=1 and get_tree().has_network_peer():
	
		if Global.alive_players[0].name == str(get_tree().get_network_unique_id()):
	#	if mmm ==1:
			winner.show()
			if $winnermusic.playing==false:
				$winnermusic.play()
		
		if win_timer.time_left <=0:
			win_timer.start()
	
