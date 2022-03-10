extends Control

func _ready():
	Global.load_game()
	for level in range($levels.get_child_count()):
		Global.levels.append(level+1) 
	
	for level in $levels.get_children():
		if str2var(level.name) in range(Global.unlockedLevels+1): 
			level.disabled = false
			level.use_parent_material = false
			level.connect('pressed', self, 'level_button_pressed', [level.name]) 
		else:
			level.disabled = true 
			level.use_parent_material = true
func level_button_pressed(lvl_no):
	get_tree().change_scene("res://gameoffline2/Scene/Node2D"+ lvl_no +".tscn") 
	


func _on_Button_pressed():
	get_tree().change_scene("res://Scene/Network_setup.tscn")
