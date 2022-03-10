extends Area2D
var in_area = []
var from_player

func explode():
	if not is_network_master():
		return
	for a in in_area:
		if a.has_method("exploded"):
			a.rpc("exploded", from_player) 
func done():
	queue_free()

func _on_bomb_body_entered(body):
	if not body in in_area:
		in_area.append(body)

func _on_bomb_body_exited(body):
	in_area.erase(body)
