extends KinematicBody2D

const speed =300
const MAX_SPEED = 20000
const ACCELERATION = 10000
const FRICTION = 8000

var hp = 100 setget set_hp
var velocity = Vector2(0,0)
export(int) var damage1 = 20

var can_shoot = true
var is_reloading = false

var player_bullet = load("res://Player_bullet.tscn")
var username_text = load("res://Username_text.tscn")

var explosion4 = preload("res://vacham.tscn")

var username setget username_set
var username_text_instance = null

puppet var puppet_hp =100 setget puppet_hp_set
puppet var puppet_position = Vector2(0,0) setget puppet_position_set  #sereetter getter thiet lap no y ma
puppet var puppet_velocity = Vector2()
puppet var puppet_rotation = 0
puppet var puppet_username = "" setget puppet_username_set

onready var tween = $Tween
onready var sprite = $Sprite
onready var reload_timer = $Reload_timer
onready var shoot_point =$Shoot_point
onready var hit_timer =$Hit_timer

func _ready():
	get_tree().connect("network_peer_connected",self,"_network_peer_connected")
	username_text_instance = Global.instance_node_at_location(username_text, Persistent_nodes, global_position)
	username_text_instance.player_following =self
	update_shoot_mode(false)
	Global.alive_players.append(self)
	
	yield(get_tree(),"idle_frame")
	if get_tree().has_network_peer():
		if is_network_master():
			Global.player_master = self
func _process(delta: float) -> void:
	if username_text_instance != null:
		username_text_instance.name = "username" +name
	if get_tree().has_network_peer():
		if is_network_master() and visible: #kiem tra day la may chu hay ko (nguoi choi hien tai), neu khong phai may chu chung ta se khong the di chuyen
			var input_vector = Vector2.ZERO
			input_vector.x = int(Input.is_action_pressed("right")) - int(Input.is_action_pressed("left"))
			input_vector.y = int(Input.is_action_pressed("down"))- int(Input.is_action_pressed("up"))
			input_vector = input_vector.normalized()
			
			if input_vector != Vector2.ZERO:
				velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
			else:
				velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta) 
		
			move_and_slide(velocity * delta)
		
			look_at(get_global_mouse_position())
			if Input.is_action_just_pressed("click") and can_shoot and not is_reloading:
				rpc("instance_bullet",get_tree().get_network_unique_id())
				is_reloading = true
				reload_timer.start()
	
		else: # neu chung ta khong phai nguoi choi hien tai (kieu player nay suat hien tren mang kia roi nhung tren mang day no ko phai nguoi choi hien tai cua no thi chi gui thong tin goc di thoi)
			rotation = lerp_angle(rotation,puppet_rotation,delta * 8)	# xac dinh gui thong tin goc quay
		
			if not tween.is_active():
				move_and_slide(puppet_velocity * speed)
	if hp<=0:
		if username_text_instance != null:
			username_text_instance.visible = false
		if get_tree().has_network_peer():
			if get_tree().is_network_server():
				rpc("destroy")
	if Input.is_action_pressed("pause"):
		get_tree().quit()
		
func lerp_angle(from, to, weight):      # lam cho goc xoay muot hon             # doi khi mot nguoi se khong xoay 1 con duong ngan nhat
	return from + short_angle_dist(from, to) *weight

func short_angle_dist(from,to):
	var max_angle = PI*2
	var difference = fmod(to - from, max_angle)
	return fmod(2*difference, max_angle) - difference
	
func puppet_position_set(new_value) -> void:
	puppet_position = new_value
	tween.interpolate_property(self,"global_position", global_position, puppet_position, 0.5) # bool cho ra true hoac false ? so sanh dich chuyen diem dau va diem cuoi xem co dich chuyen vi tri ko
	# Global_position lấay viị trí chuột bên ngaoif màn hình
	# global_position lấay vi tri cua no so voi diem i(0,0)  con position ko thif laay tuong doi so voi node parent
	tween.start()
	#  nhan voi delta de muon no gan voi thoi gian thuc trong tro choi thay vi khung hinh
func set_hp(new_value):
	hp = new_value
	
	if get_tree().has_network_peer():
		if is_network_master():
			rset("puppet_hp",hp)
func puppet_hp_set(new_value):
	puppet_hp = new_value
	if get_tree().has_network_peer():
		if not is_network_master():
			hp=puppet_hp
func username_set(new_value) -> void:
	username = new_value
	
	if get_tree().has_network_peer():
		if is_network_master() and username_text_instance != null:
			username_text_instance.text = username
			rset("puppet_username",username)
func puppet_username_set(new_value)-> void:
	puppet_username = new_value
	if get_tree().has_network_peer():
		if not is_network_master() and username_text_instance != null:
			username_text_instance.text = puppet_username
func _network_peer_connected(id) -> void:
	rset_id(id,"puppet_username", username)
func _on_Network_tick_rate_timeout():
	if get_tree().has_network_peer():
		if is_network_master():
			rset_unreliable("puppet_position", global_position)      # dung de tu xa thay doi bien
			rset_unreliable("puppet_velocity", velocity) # gui thong tin vi tri cua vat the 
			rset_unreliable("puppet_rotation", rotation) # gui goc quay cua vat the di
sync func instance_bullet(id):
	var player_bullet_instance = Global.instance_node_at_location(player_bullet, Persistent_nodes, shoot_point.global_position)
	player_bullet_instance.name = "Bullet" + name +str(Network.networked_object_name_index)
	player_bullet_instance.set_network_master(id)
	player_bullet_instance.player_rotation = rotation
	player_bullet_instance.player_owner = id
	Network.networked_object_name_index +=1

sync func update_position(pos):
	global_position = pos
	puppet_position = pos

func update_shoot_mode(shoot_mode):
	if not shoot_mode:
		pass
	else:
		pass
	can_shoot = shoot_mode

func _on_Reload_timer_timeout():
	is_reloading = false


func _on_Hit_timer_timeout():
	modulate = Color(1,1,1,1)


func _on_Hitbox_area_entered(area):
	if get_tree().is_network_server():
		if area.is_in_group("Player_damager") and area.get_parent().player_owner != int(name):
			rpc("hit_by_damager", area.get_parent().damage)
			
			area.get_parent().rpc("destroy")
	if area.is_in_group("dog"):
		velocity  = Vector2.UP * 20000
		velocity = velocity.move_toward(Vector2.ZERO,200)
		#velocity  = move_and_slide(velocity )
	if area.is_in_group("lua"):
		var explosion_instance = explosion4.instance()
		explosion_instance.position = get_global_position()
		get_tree().get_root().add_child(explosion_instance)
		rpc("hit_by_damager", damage1)
			
	
sync func hit_by_damager(damage):
	hp -= damage
	modulate = Color(5,5,5,1)
	hit_timer.start()
	
	
sync func enable() -> void:
	hp =100	
	can_shoot = false
	update_shoot_mode(false)
	username_text_instance.visible = true
	visible = true
	$CollisionShape2D.disabled = false
	$Hitbox/CollisionShape2D.disabled = false
	
	if get_tree().has_network_peer():
		if is_network_master():
			Global.player_master = self	
	
	if not Global.alive_players.has(self):
		Global.alive_players.append(self)
			
sync func destroy() -> void:
	username_text_instance.visible = false
	visible = false
	$CollisionShape2D.disabled= true
	$Hitbox/CollisionShape2D.disabled = true
	Global.alive_players.erase(self)
	if get_tree().has_network_peer():
		if is_network_master():
			Global.player_master = null

func _exit_tree() -> void:
	Global.alive_players.erase(self)
	if get_tree().has_network_peer():
		if is_network_master():
			Global.player_master = null


func _on_Area2D_body_entered(body):
	print("laivanhieu")
	print(body.name)

