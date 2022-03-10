extends KinematicBody2D
var time_jump_apex =0.4
var gravity 
var jump_height =65
var jump_force
var on_ground = false
var can_double_jump = false
var velocity = Vector2(0,0)
var speed =150
var m=1
var gg = -1
var huongdan =1
onready var bullet = preload("res://gameoffline2/Scene/Bullet.tscn")
onready var granada = preload("res://gameoffline2/Scene/boom.tscn")
var g
var b
func _physics_process(delta):
	gravity = (2*jump_height)/pow(time_jump_apex,2)
	jump_force = gravity *time_jump_apex
	velocity.y += gravity *delta		
	if Input.is_action_pressed("left"):
		velocity.x = -speed	
	elif Input.is_action_pressed("right"):
		velocity.x = speed
	else:
		velocity.x =0
	if Input.is_action_just_pressed("up"):
		if m==1:
			m=2
			$animationhero.play("jump")
		velocity.y = -jump_force
	if m==1:
		if velocity.x <0:
			$animationhero.flip_h = true
			gg=1
			Tonghop.m=2
			$animationhero.play("run")
		elif velocity.x > 0:
			$animationhero.flip_h = false
			gg=-1
			Tonghop.m=1
			$animationhero.play("run")
		elif velocity.x==0 :
			$animationhero.play("idle")
	velocity = move_and_slide(velocity, Vector2.UP)
	if is_on_floor():
		on_ground = true
		can_double_jump = false
		if velocity.x != 0:
			pass
	else:
		on_ground = false
		if m==1:
			$animationhero.play("jump")
	if Input.is_key_pressed(KEY_ENTER):
		get_tree().change_scene("res://gameoffline2/mainarmy.tscn")
	if Input.is_action_just_pressed("click2"):
		if Global.selected_gun==1:
			$audio.play()
			m=2
			$animationhero.play("shoot")
			b = bullet.instance()
			get_parent().add_child(b)
			if gg==-1:
				b.global_position = $Position2D.global_position
			else:
				b.global_position = $Position2D2.global_position
		else:
			g = granada.instance()
			get_parent().add_child(g)
			g.init(gg)

			g.global_position = $Position2D3.global_position
			
			g.throw(Vector2(250,-500))


func _on_animationhero_animation_finished():
	m=1
