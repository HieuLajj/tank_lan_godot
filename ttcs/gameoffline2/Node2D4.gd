extends Node2D



func _on_Timer_timeout():
	if $CanvasModulate.visible==true:
		$CanvasModulate.visible=false
	else:
		$CanvasModulate.visible=true
