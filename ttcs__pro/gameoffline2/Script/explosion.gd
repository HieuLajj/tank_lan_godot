extends Node2D

signal exploded
func _ready():
	$audio.play()
	$AnimatedSprite.play("explode")


func _on_AnimatedSprite_animation_finished():
	$AnimatedSprite.stop()
	emit_signal("exploded")
