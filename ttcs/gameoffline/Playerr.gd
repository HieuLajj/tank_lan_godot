extends Sprite

var speed = 150
var velocity = Vector2()

var bullet = preload("res://gameoffline/Bullett.tscn")
var audio_tiengban = load("res://music/Tiengsung1phat.ogg")
var can_shoot = true
var is_dead = false

var damage = 1
var default_damage = damage

var reload_speed = 0.1
var default_reload_speed = reload_speed

var power_up_reset = []

func _ready():
	Global.player = self

func _exit_tree():
	Global.player = null

func _process(delta):
	velocity.x = int(Input.is_action_pressed("right")) - int(Input.is_action_pressed("left"))
	velocity.y = int(Input.is_action_pressed("down")) - int(Input.is_action_pressed("up"))
	
	velocity = velocity.normalized()
	global_position.x = clamp(global_position.x, 24, 616)
	global_position.y = clamp(global_position.y, 24, 336)
	
	if is_dead == false:
		global_position += speed * velocity * delta
	look_at(get_global_mouse_position())
	if Input.is_action_pressed("click") and Global.node_creation_parent != null and can_shoot and is_dead == false:
		var bullet_instance = Global.instance_node_1(bullet, global_position, Global.node_creation_parent)
		bullet_instance.damage = damage
		$Reload_speed.start()
		
		#$audio3.stream = audio_tiengban
		
		$audio3.stream = audio_tiengban
		$audio3.play()
		can_shoot = false
	#if !Input.is_action_pressed("click"):
		#$audio3.playing = false



func _on_Reload_speed_timeout():
	can_shoot = true
	$Reload_speed.wait_time = reload_speed


func _on_Hitbox_area_entered(area):
	if area.is_in_group("Enemy"):
		is_dead = true
		visible = false
		#Global.save_game()
		yield(get_tree().create_timer(1), "timeout")
		get_tree().reload_current_scene()


func _on_Power_up_cool_down_timeout():
	if power_up_reset.find("Power_up_reload") != null:
		reload_speed = default_reload_speed
		power_up_reset.erase("Power_up_reload")
	elif power_up_reset.find("Power_up_damage") != null:
		damage = default_damage
		power_up_reset.erase("Power_up_damage")

