extends Control

func _ready():
	set_colors()
func set_colors():
	if Global.selected_gun ==1:
		$"ColorRect/CenterContainer/HBoxContainer/TextureRect/RichTextLabel".modulate = Color.white
		$"ColorRect/CenterContainer/HBoxContainer/TextureRect2/RichTextLabel".modulate = Color.black
	else:
		$"ColorRect/CenterContainer/HBoxContainer/TextureRect/RichTextLabel".modulate = Color.black
		$"ColorRect/CenterContainer/HBoxContainer/TextureRect2/RichTextLabel".modulate = Color.white
func _input(event):
	if Input.is_action_just_pressed("num_1"):
		Global.selected_gun =1
		set_colors()
	if Input.is_action_just_pressed("num_2"):
		Global.selected_gun=2
		set_colors()
		
	
