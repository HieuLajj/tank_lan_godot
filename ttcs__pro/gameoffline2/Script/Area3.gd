extends Area2D



func _on_Area3_body_entered(body):
	if body.name == 'hero':
		Global.leveltronggame +=1
		Global.unlockedLevels += 1 
		Global.save_game()
		get_tree().change_scene("res://gameoffline2/Scene/Node2D"+ str(Global.leveltronggame) +".tscn") # Change scene to the next level
