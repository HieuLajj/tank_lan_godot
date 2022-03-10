extends KinematicBody2D

func _ready():
	$Sprite.visible = true
puppet func do_explosion():
	get_node("anim").play("explode")

master func exploded(by_who):
	rpc("do_explosion") 
	#get_node("../../score").rpc("increase_score", by_who)
	do_explosion()
