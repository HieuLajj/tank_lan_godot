extends Node2D

const SPEED =300

func _physics_process(delta):
	position.x += -SPEED* delta
	if global_position.x <= -450:
		queue_free()
		
