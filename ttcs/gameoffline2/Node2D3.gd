extends Node2D
var i=0
func _process(delta):
	
	$TileMap.set_rotation_degrees(10+i)
	i+=.1

