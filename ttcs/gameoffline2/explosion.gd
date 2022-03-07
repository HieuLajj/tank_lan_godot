extends Node2D

signal exploded
func _ready():
	$AnimatedSprite.play("explode")


func _on_AnimatedSprite_animation_finished():
	$AnimatedSprite.stop()
	emit_signal("exploded")
