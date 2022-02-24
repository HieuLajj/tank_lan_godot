extends Node2D
onready var timer = $Timer
var Obstacle = preload("res://Obstacle.tscn")
var m =1
func _ready():
	$Timer2.start()
	randomize()

func _on_Timer_timeout():
	if m==2:
		spawn_obstacle()
func spawn_obstacle():
	var obstacle = Obstacle.instance()
	add_child(obstacle)
	obstacle.position.y = randi()%100+10
func start():
	timer.start()
func sop():
	timer.stop()



func _on_Timer2_timeout():
	#timer.start()
	m=2
