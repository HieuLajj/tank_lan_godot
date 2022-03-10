extends KinematicBody2D

const FLOOR_NORMAL : = Vector2(0, -1)

var gravity : = 0
var speed : = 100.0
var velocity : = Vector2()
var target_speed : = 0.0

onready var animated_sprite =$Sprite
onready var ray : RayCast2D = $RayCast2D as RayCast2D


func _process(delta: float) -> void:
	if velocity.y > 0:
		animated_sprite.flip_v = false
	elif velocity.y < 0:
		animated_sprite.flip_v = true



func _physics_process(delta: float) -> void:
	get_inputs()

	#velocity.y = velocity.y + gravity

	velocity.y = -lerp(velocity.y, target_speed, .4)

	if abs(velocity.y) < 1:
		velocity.y = 0

	var snap : = Vector2.DOWN * 8
	velocity = move_and_slide_with_snap(velocity, snap, FLOOR_NORMAL)

#	if get_slide_count():
#		for i in range(get_slide_count()):
#			if get_slide_collision(i).get_collider() is Player:
#				var player : = get_slide_collision(i).get_collider() as Player
#				player.damage()

#				ray.cast_to.x *= -1


func get_inputs() -> void:
	if ray.is_colliding():
		ray.cast_to.y *= -1

	target_speed = sign(ray.cast_to.y) * speed
