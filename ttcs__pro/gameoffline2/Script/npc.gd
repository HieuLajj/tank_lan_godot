extends Node2D
var dialog = null
func _ready():
	$speek.visible= false

func _on_Area2D_body_entered(body):
	if get_node_or_null("DialogNode")==null:
		dialog = Dialogic.start('start')
		dialog.connect('dialogic_signal',self,'dialog_msg')
		add_child(dialog)
	$speek.visible= true


func _on_Area2D_body_exited(body):
	$speek.visible= false
func dialog_msg(msg):
	print(msg)
