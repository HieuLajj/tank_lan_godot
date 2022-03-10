extends Node2D

onready var bullet = preload("res://gameoffline2/Scene/Bullet_enemy.tscn")
var b
func _physics_process(delta):
	if $AnimatedSprite/RayCast2D.is_colliding():
		$Icon.visible = true
		if $Timer.is_stopped():
			print("nai")
			$Timer.start()
	else:
		$Icon.visible = false
		if not $Timer.is_stopped():
			$Timer.stop()
	#if area.is_in_group("bullet"):
	#	print("Fawe")
#	area.queue_free()
	#queue_free()

func shoot(dir):
		b = bullet.instance()
		get_parent().add_child(b)
		b.global_position = $Position2D.global_position
func _on_Timer_timeout():
	shoot(true)


func _on_Area2D_area_entered(area):
	if area.is_in_group("bullet"):
		queue_free()
