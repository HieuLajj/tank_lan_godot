extends KinematicBody2D

var speed =150
var MAX_SPEED = 20000
var ACCELERATION = 9000
var FRICTION = 8000

var hp = 100 setget set_hp
var velocity = Vector2(0,0)
export(int) var damage0 = 5
export(int) var damage1 = 20
export(int) var damage2 = 10
export(int) var damage3 = 20
var checkdamage = 3
var loopdamage = null

var can_shoot = true
var is_reloading = false

var player_bullet = load("res://Player_bullet.tscn")
var username_text = load("res://Username_text.tscn")
#hp day ne
var hpdayne = load("res://hpnhanvat.tscn")

var explosion4 = preload("res://vacham.tscn")
var explosion5hp = preload("res://itemhppowder/hieuunghoimau.tscn")
var explosion6tocdo =preload("res://itemhppowder/hieuungtangtoc.tscn")
var hieuungsauchet = preload("res://godpowder.tscn")

var username setget username_set
var username_text_instance = null
#hp 
var mau setget hp_set
var hp_instance = null
#trangthaitank
var tankdo= null
#trangthaidan
var bullet = preload("res://Player_bullet.tscn")
var gg = preload("res://mapPack/dannay/Fmothai.png")
var ge = "fawefa"

puppet var puppet_tankdohoa setget puppet_tankdohoa_set
var tankdohoa setget  tankdohoa_set

puppet var puppet_hp =100 setget puppet_hp_set
puppet var puppet_position = Vector2(0,0) setget puppet_position_set  #sereetter getter thiet lap no y ma
puppet var puppet_velocity = Vector2()
puppet var puppet_rotation = 0
puppet var puppet_username = "" setget puppet_username_set
#remote var puppet_username = "" setget puppet_username_set
puppet var puppet_mau = "" setget puppet_mau_set

onready var tween = $Tween
onready var sprite = $Sprite
onready var reload_timer = $Reload_timer
onready var shoot_point =$Shoot_point
onready var hit_timer =$Hit_timer
onready var heal_timer = $Heal_timer

var b =null
var bg = null
# trong luc
puppet var puppet_velocity2 = Vector2()
var jump_height =65
var time_jump_apex =0.4
var gravity 
var gravity2 =0
var jump_force
var on_ground = false
var can_double_jump = false
var audio_jump = load("res://music/jump.wav")
var audio_run = load("res://music/foot_sound.wav")
var audio_food = load("res://music/Fantozzi-SandR1.ogg")
var audio_datbom = load("res://music/51_ring.wav")
var audio_coin = load("res://music/nhatcoin.wav")
var audio_tiengxe = load("res://music/tiengxetank.ogg")
var eh=1
# map 4
var prev_bombing = false
export var stunned = false
export var stunned2 = false
puppet var puppet_motion = Vector2()
#item
var itemdem = 1
var itemdem2 = 1
var itemdem3 = 1
#pac man
var pacmana= 1
var rgb =1
func _ready():
	get_tree().connect("network_peer_connected",self,"_network_peer_connected")
	username_text_instance = Global.instance_node_at_location(username_text, Persistent_nodes, global_position)
	username_text_instance.player_following =self
	
	#hp
	hp_instance = Global.instance_node_at_location(hpdayne, Persistent_nodes, global_position)
	hp_instance.player_following2 = self
	
	update_shoot_mode(false)
	Global.alive_players.append(self)
	
	yield(get_tree(),"idle_frame")
	if get_tree().has_network_peer():
		if is_network_master():
			Global.player_master = self
	b=1
	bg=get_tree().get_network_unique_id()
	
#	while message.text.length()!=0:
#		message.delete_char_at_cursor()
	Tonghop.tennhanvatset(username)
	stunned = false
	stunned2 = false
	#$audio2.set_bus_volume_db(0,12)
func _process(delta: float) -> void:
	#if tankdohoa =="2":
	#	Tonghop.danbanset("dannangcap")
	var motion =Vector2()
	#hp xet
	if username_text_instance != null:
		username_text_instance.name = "username" +name
	#if Tonghop.nhanvat=="map2":
	#			if get_tree(). get_network_connected_peers():
	#				set_rotation(0)
	#				$Sprite.hide()
	#				$ninja.show()
	#				rpc("switch_to_game")
	if get_tree().has_network_peer():
		if is_network_master() and visible: #kiem tra day la may chu hay ko (nguoi choi hien tai), neu khong phai may chu chung ta se khong the di chuyen
			#var input_vector = Vector2.ZERO
			#test map 2
			if Tonghop.nhanvat=="map2":
				#ACCELERATION = 0 
				#FRICTION = 0
			#	velocity = velocity.move_toward(Vector2.ZERO, 0 * delta) 
				set_rotation(0)
				if hp>0:
					$Sprite.hide()
					$ninja.show()
				gravity = (2*jump_height)/pow(time_jump_apex,2)
				jump_force = gravity *time_jump_apex
				velocity.y += gravity *delta		
				if Input.is_action_pressed("left"):
					velocity.x = -speed	
				elif Input.is_action_pressed("right"):
					velocity.x = speed
				else:
					velocity.x =0
				rset("puppet_velocity2",velocity)
				if Input.is_action_just_pressed("up"):
					if on_ground:
						velocity.y = -jump_force
						on_ground = false
						$audio2.stream = audio_jump
						$audio2.play()
						can_double_jump = true
					else:
						if can_double_jump:
							velocity.y = -jump_force
							can_double_jump = false
				velocity = move_and_slide(velocity, Vector2.UP)
				if is_on_floor():
					on_ground = true
					can_double_jump = false
				#	if velocity.x==0:
				#		$ninja.play("idle")
				#	else:
				#		$ninja.play("run")
				#		$audio2.stream = audio_run
				#		$audio2.play()
					if velocity.x != 0:
						$audio2.stream = audio_run
						$audio2.play()
				else:
					on_ground = false
					$ninja.play("jump")
			elif Tonghop.nhanvat=="map3":
				set_rotation(0)
				#velocity.x = Vector2.ZERO
				if hp>0:
					$Sprite.hide()
					$plane.show()
				if eh ==1:
					gravity = 0
				else:
					gravity = (2*jump_height)/pow(time_jump_apex,2)
				#gravity = (2*jump_height)/pow(time_jump_apex,2)
				jump_force = gravity *time_jump_apex
				velocity.y += gravity *delta
				
				if Input.is_action_just_pressed("up"):
					eh =2
					velocity.y = -jump_force
			
					$audio2.stream = audio_jump
					$audio2.play()
				if Input.is_action_pressed("left"):
					velocity.x = -60
				if Input.is_action_pressed("right"):
					velocity.x = +60
				velocity = move_and_slide(velocity, Vector2.UP)
			elif Tonghop.nhanvat == "map1":
				set_rotation(0)
				$Sprite.hide()
				$dogy.show()
				if Input.is_action_pressed("left"):
					motion += Vector2(-1,0) 
				if Input.is_action_pressed("right"):
					motion += Vector2(1,0) 
				if Input.is_action_pressed("up"):
					motion += Vector2(0,-1) 
				if Input.is_action_pressed("down"):
					motion += Vector2(0,1) 
				if stunned2:
					motion = Vector2()	
				var bombing = Input.is_action_just_pressed("set_bomb")
				if bombing and not prev_bombing:
					if itemdem>0:
						var bomb_name = username
						var bomb_pos = position
						rpc("setup_bomb", bomb_name, bomb_pos, get_tree().get_network_unique_id())
						itemdem -=1
				rset("puppet_motion", motion)
				if motion.x != 0 or motion.y !=0:
					if $audio2.playing == false:
						$audio2.stream = audio_food
						$audio2.play()
			elif Tonghop.nhanvat=="map4":
				set_rotation(0)
				$Sprite.hide()
				$bomber.show()
				if Input.is_action_pressed("left"):
					motion += Vector2(-1,0)
				if Input.is_action_pressed("right"):
					motion += Vector2(1,0)
				if Input.is_action_pressed("up"):
					motion += Vector2(0,-1)
				if Input.is_action_pressed("down"):
					motion += Vector2(0,1)
				var bombing = Input.is_action_pressed("set_bomb")
				
				if stunned:
					bombing = false
					motion = Vector2()	
				if bombing and not prev_bombing:
				#	if $audio2.playing == false:
					$audio2.stream = audio_datbom
					$audio2.play()
					var bomb_name = username
					var bomb_pos = position
					rpc("setup_bomb", bomb_name, bomb_pos, get_tree().get_network_unique_id())

				prev_bombing = bombing
				rset("puppet_motion", motion)
				if motion.x != 0 or motion.y !=0:
					if $audio2.playing == false:
						$audio2.stream = audio_food
						$audio2.play()
			else: 
				var input_vector = Vector2.ZERO
				input_vector.x = int(Input.is_action_pressed("right")) - int(Input.is_action_pressed("left"))
				input_vector.y = int(Input.is_action_pressed("down"))- int(Input.is_action_pressed("up"))
				input_vector = input_vector.normalized()
			
				if input_vector != Vector2.ZERO:
					velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
					$audio2.stream = audio_tiengxe
					$audio2.play()
				else:
					if $audio2.stream ==audio_tiengxe and $audio2.playing==true:
						$audio2.playing = false
					
				#	velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta) 
					velocity = Vector2.ZERO
		
				move_and_slide(velocity * delta)
				#input_vector.x = Input.get_action_strength("right") - Input.get_action_strength("left")
				#input_vector.y = Input.get_action_strength("down") - Input.get_action_strength("up")
				#if input_vector != Vector2.ZERO:
				#	velocity = input_vector
				#else:
				#	velocity = Vector2.ZERO
				#move_and_collide(velocity*200*delta)
					
				look_at(get_global_mouse_position())
			# vao trong vong 1 tab
				if Input.is_action_just_pressed("click") and can_shoot and not is_reloading:
					if loopdamage ==2:
						dannangcap()
						dannangcap()
					else:
						dannangcap()
				var bombing = Input.is_action_just_pressed("set_bomb")
			#	var bombing = Input.is_action_pressed("set_bomb")
				#if stunned:
				#	bombing = false
					#motion = Vector2()	
				if bombing and not prev_bombing:
					if itemdem>0 and Tonghop.kiemtramap==2:
						var bomb_name = username
						var bomb_pos = position
						rpc("setup_bomb", bomb_name, bomb_pos, get_tree().get_network_unique_id())
						itemdem -=1
				var smoking = Input.is_action_just_pressed("smoke")
			#	var bombing = Input.is_action_pressed("set_bomb")
				#if stunned:
				#	bombing = false
					#motion = Vector2()	
				if smoking and not prev_bombing:
					if itemdem2 >0 and Tonghop.kiemtramap==2:
						var bomb_name = username
						var bomb_pos = position
						rpc("setup_bomb2", bomb_name, bomb_pos, get_tree().get_network_unique_id())
						itemdem2 -= 1
				var thundering = Input.is_action_just_pressed("thunder")
			#	var bombing = Input.is_action_pressed("set_bomb")
				#if stunned:
				#	bombing = false
					#motion = Vector2()	
				if thundering and not prev_bombing:
					if itemdem3 >0 and Tonghop.kiemtramap==2:
						var bomb_name = username
						var bomb_pos = position
						rpc("setup_bomb3", bomb_name, bomb_pos, get_tree().get_network_unique_id())
						itemdem3 -= 1
			#move_and_slide(Vector2(0,0),Vector2(0,0))
			
			#if Input.is_action_just_pressed("chatbox"):
			#	if $CanvasLayer/chatbox.visible ==true:
			#		$CanvasLayer/chatbox.visible = false
			#	else:
			#		$CanvasLayer/chatbox.visible = true
			#if Input.is_action_just_pressed("chuyen"):
			#	Tonghop.nhanvatset("map2")
			
				
			
				#print("bannay")
				#rpc("instance_bullet",get_tree().get_network_unique_id())
				#is_reloading = true
				#reload_timer.start()
				#$audio.play()
			#if Input.is_action_just_pressed("home"):
				#Network.disconnect_server()
			#	get_tree().change_scene("res://GUI.tscn")
			#	Network.disconnect_server()
				#tankdohoa_set("2")
			#if Input.is_action_just_pressed("testdan"):
				##ge="lai"
			#	tankdohoa_set("2")
			#	if $CanvasLayer/chatbox.show():
			#		$CanvasLayer/chatbox.hide()
	
				if tankdohoa !="2":
					if hp>200:
						tankdohoa_set("1")
					elif hp<100:
						tankdohoa_set("3")
				
		else: # neu chung ta khong phai nguoi choi hien tai (kieu player nay suat hien tren mang kia roi nhung tren mang day no ko phai nguoi choi hien tai cua no thi chi gui thong tin goc di thoi)
			if Tonghop.nhanvat=="map2":
				set_rotation(0)
			#	if $Sprite.visible:
			#		$Sprite.hide()
			#		$ninja.show()
				if hp>0:
					$Sprite.hide()
					$ninja.show()
				velocity = puppet_velocity2
			if Tonghop.nhanvat == "map3":
				set_rotation(0)
			#	if $Sprite.visible:
			#		$Sprite.hide()
			#		$ninja.show()
				if hp>0:
					$Sprite.hide()
					$plane.show()
			if Tonghop.nhanvat == "map4":
				set_rotation(0)				
				$Sprite.hide()
				$bomber.show()
				motion = puppet_motion
			if Tonghop.nhanvat == "map1":
				set_rotation(0)	
				$Sprite.hide()
				$dogy.show()
				motion = puppet_motion
			rotation = lerp_angle(rotation,puppet_rotation,delta * 8)	# xac dinh gui thong tin goc quay
		
			if not tween.is_active():
				move_and_slide(puppet_velocity * speed)
		if velocity.x <0:
			$ninja.flip_h = true
			$ninja.play("run")
		elif velocity.x > 0:
			$ninja.flip_h = false
			$ninja.play("run")
		elif velocity.x==0:
			$ninja.play("idle")
		#map4
		move_and_slide(motion * speed * pacmana)
		if motion.y < 0:
			$bomber.play("luisau")
			$dogy.play("lui")
		elif motion.y > 0:
			$bomber.play("tienlen")
			$dogy.play("tien")
		elif motion.x < 0:
			$bomber.play("sangtrai")
			$dogy.play("trai")
		elif motion.x > 0:
			$bomber.play("sangphai")
			$dogy.play("phai")
		if stunned:
			$bomber.play("trungbomb")
			
			hp -=0.5
		if stunned2:
			$dogy.play("trung")
				
	
		hp_set(String(hp))
		
	
	if hp<=0:
		if username_text_instance.visible == true:
			var explosion_instance = hieuungsauchet.instance()
			explosion_instance.position = get_global_position()
			get_tree().get_root().add_child(explosion_instance)

		if username_text_instance != null:
			username_text_instance.visible = false
		if hp_instance != null:
			hp_instance.visible = false
		if get_tree().has_network_peer():
			if get_tree().is_network_server():
				rpc("destroy")
	if Input.is_action_pressed("pause"):
		$CanvasLayer/menu.visible = true
		#for player in Persistent_nodes.get_children():
		#	if player.is_in_group("Player"):
		#		player.visible = false
		#		player.update_shoot_mode(false)
		#Global.instance_node(load("res://PauseMenu2.tscn"), Global.ui)
		#pass
	#	for child in Persistent_nodes.get_children():
	#	if child.is_in_group("Player"):
		#	Tonghop.danbanset("danthuong")
	#		child.update_shoot_mode(true)
		#$PauseMenu2.visible = true
		#Global.instance_node(load("res://PauseMenu2.tscn"),self)
		#get_tree().change_scene("res://PauseMenu2.tscn")
		#Global.instance_node(load("res://PauseMenu2.tscn"),self)
		#get_tree().quit()
		
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
	#hp_set(String(hp))
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
		if is_network_master() and username_text_instance != null and is_instance_valid(username_text_instance):
			username_text_instance.text = username
			rset_config("puppet_username", MultiplayerAPI.RPC_MODE_REMOTESYNC)
			rset("puppet_username",username)
			#rset("puppet_username",username)
	
func puppet_username_set(new_value)-> void:
	puppet_username = new_value
	if get_tree().has_network_peer():
		if not is_network_master() and username_text_instance != null and is_instance_valid(username_text_instance):
			username_text_instance.text = puppet_username
# tank do hoa
func tankdohoa_set(new_value)-> void:
	tankdohoa = new_value
	if get_tree().has_network_peer():
		if is_network_master():
			chuyendoitrangthaitank(tankdohoa)
			#$Sprite.set_texture(tankdohoa)
			rset("puppet_tankdohoa",tankdohoa)
func puppet_tankdohoa_set(new_value)-> void:
	puppet_tankdohoa = new_value
	if get_tree().has_network_peer():
		if not is_network_master():
			chuyendoitrangthaitank(puppet_tankdohoa)	
		#	$Sprite.set_texture(puppet_tankdohoa)
func chuyendoitrangthaitank(a) -> void:
	if a=="1":
		tankdo = preload("res://mapPack/tankaa/tank3-removebg-preview.png")
		loopdamage = 1
		checkdamage =1
	elif a=="2":
		tankdo = preload("res://mapPack/tankaa/tank1-removebg-preview.png")
	#	Tonghop.danbanset("dannangcap")
		loopdamage = 2
		checkdamage =2
	elif a=="3":
		tankdo =preload("res://mapPack/tankaa/tank2-removebg-preview.png")
		loopdamage = 3
		checkdamage =3
	$Sprite.set_texture(tankdo)
#hp
func hp_set(new_value)-> void:
	mau = new_value
	if get_tree().has_network_peer():
		if is_network_master() and 	hp_instance != null and is_instance_valid(hp_instance):
			hp_instance.text2 = mau
			rset("puppet_mau",mau)
func puppet_mau_set(new_value):
	puppet_mau = new_value
	if get_tree().has_network_peer():
		if not is_network_master() and hp_instance != null and is_instance_valid(hp_instance):
			#hp_instance.text2 = mau
			hp_instance.text2 = puppet_mau
			pass

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
	#if ge=="lai":
		#player_bullet_instance.texture= load("res://mapPack/dannay/tankfire.png")
	#if get_tree().has_network_peer():
	#player_bullet_instance.bulletdohoa_set("dannangcap")
	#player_bullet_instance.get_instance_id(id).bulletdohoa_set("dohoanangcap")
	#print("hêolfaw")
#	print(id)
	player_bullet_instance.name = "Bullet" + name +str(Network.networked_object_name_index)
	player_bullet_instance.set_network_master(id)
	player_bullet_instance.player_rotation = rotation
	player_bullet_instance.player_owner = id
	Network.networked_object_name_index +=1
	
	player_bullet_instance.dannhunao = "1"

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
			if checkdamage ==1:
				rpc("hit_by_damager", damage2)
			elif checkdamage ==2:
				rpc("hit_by_damager", damage3)
			else:
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
	if area.is_in_group("lua2"):
		rpc("hit_by_damager", 5)
	if area.is_in_group("ninja"):
		speed -=10
		print(speed)
		rpc("setup_bomb0", position)
	if area.is_in_group("angle"):
		exploded2()
		speed = 0
	if area.is_in_group("pacmanchoang"):
		pacmana = -1
	if area.is_in_group("tuong"):
		rpc("hit_by_damager", damage0)
	if area.is_in_group("redzone"):
		rpc("hit_by_damager", 1000)
	if area.is_in_group("hieuunghp"):
		var explosion_instance = explosion5hp.instance()
		explosion_instance.position = get_global_position()
		get_tree().get_root().add_child(explosion_instance)
		hp=hp+25
		$audio33.play()
		#heal_timer.start()
		#hit_timer.start()
		#set_hp(hp)
		#hp_set(String(hp))
		#hp_set(String(hp))
	if area.is_in_group("hieuungtocdo"):
		var explosion_instance = explosion6tocdo.instance()
		explosion_instance.position = get_global_position()
		get_tree().get_root().add_child(explosion_instance)
		MAX_SPEED +=250
		$audio33.play()
	if area.is_in_group("hieuunggotpowder") and Tonghop.kiemtramap==2:
			tankdohoa_set("2")
	if area.is_in_group("thembomb"):
		$audio33.play()
		itemdem +=3
	if area.is_in_group("themsmoke"):
		$audio33.play()
		itemdem2 +=3
	if area.is_in_group("khoidoc"):
		speed -=20
		print(speed)
	if area.is_in_group("enemy"):
		var explosion_instance = explosion4.instance()
		explosion_instance.position = get_global_position()
		get_tree().get_root().add_child(explosion_instance)
		rpc("hit_by_damager", damage1)
	if area.is_in_group("hoiphuctocdo"):
		speed = 150
	if area.is_in_group("ngoc3"):
		if is_network_master(): 
			Tonghop.kiemtraminigame=2
#		else:
#			Tonghop.kiemtraminigame=1
		
sync func hit_by_damager(damage):
	if $trungroi.playing == false:
		$trungroi.play()
	hp -= damage
#	hp_set(String(hp))
	modulate = Color(5,5,5,1)
	hit_timer.start()
	
	
sync func enable() -> void:
	pacmana = 1
	hp =100	
	hp_set(String(hp))
	speed = 150
	$Sprite.show()
	$ninja.hide()
	$plane.hide()
	$bomber.hide()
	$dogy.hide()
	can_shoot = false
	update_shoot_mode(false)
	username_text_instance.visible = true
	hp_instance.visible = true
	visible = true
	Tonghop.danbanset("danthuong")
	$CollisionShape2D.disabled = false
	$Hitbox/CollisionShape2D.disabled = false
	
	if get_tree().has_network_peer():
		if is_network_master():
			Global.player_master = self	
	
	if not Global.alive_players.has(self):
		Global.alive_players.append(self)
			
sync func destroy() -> void:
	username_text_instance.visible = false
	hp_instance.visible = false
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

func dannangcap() -> void:
	var bullet_instance = bullet.instance()
	#bullet_instance.dannhunao="vzvs"
	rpc("instance_bullet",get_tree().get_network_unique_id())
	is_reloading = true
	reload_timer.start()
	$audio.play()


func _on_audio_finished():
	pass


func _on_giamamluong_pressed():
	AudioServer.set_bus_volume_db(0,AudioServer.get_bus_volume_db(0)-1)
	

func _on_tangamluong_pressed():
	AudioServer.set_bus_volume_db(0,AudioServer.get_bus_volume_db(0)+1)
	


func _on_Resume_game_pressed():
	$CanvasLayer/menu.visible = false
	
func _on_chuyenchedo_pressed():
	if $nhacnen.playing == false:
		$nhacnen.play()
	else:
		$nhacnen.stop()

func _on_Quit_game_pressed():
	get_tree().quit()


func _on_Back_lobby_pressed():
	get_tree().change_scene("res://GUI.tscn")
	Network.disconnect_server()


func _on_chuyenbainen_pressed():
	#var rng = RandomNumberGenerator.new()
	#rng.randomize()
#	if rng.randi_range(1,3)==1:
	match rgb:
		1:
			$nhacnen.stream =load("res://music/bells2_1.ogg")
	#if rng.randi_range(1,3)==2:
		2:
			$nhacnen.stream =load("res://music/TheLoomingBattle.OGG")
	#else:
		3:
			$nhacnen.stream =load("res://music/Last-Minute.ogg")
		4:
			$nhacnen.stream = load("res://music/Middle_age_RPG_Theme_1.ogg")
		5:
			$nhacnen.stream = load("res://music/Middle_age_RPG_Theme_2.ogg")
		6:
			$nhacnen.stream = load("res://music/Town.ogg")
		7:
			$nhacnen.stream = load("res://music/Campaign.ogg")
		8:
			$nhacnen.stream = load("res://music/Castle.ogg")
	rgb +=1
	if rgb ==9:
		rgb =1
	print(rgb)
	if $nhacnen.playing == false:
		$nhacnen.play()
	else:
		$nhacnen.stop()
		$nhacnen.play()
sync func setup_bomb0(pos):
	var bomb = preload("res://minigame/bomb.tscn").instance()
	bomb.position = pos
	get_node("../..").call_deferred("add_child",bomb)
sync func setup_bomb(bomb_name, pos, by_who):
	var bomb = preload("res://minigame/bomb.tscn").instance()
	bomb.set_name(bomb_name)
	bomb.position = pos
	bomb.from_player = by_who
	get_node("../..").add_child(bomb)
sync func setup_bomb2(bomb_name, pos, by_who):
	var bomb = preload("res://minigame/firefire.tscn").instance()
	bomb.set_name(bomb_name) 
	bomb.position = pos
	bomb.from_player = by_who
	get_node("../..").add_child(bomb)
sync func setup_bomb3(bomb_name, pos, by_who):
	var bomb = preload("res://minigame/thunder.tscn").instance()
	bomb.set_name(bomb_name) 
	bomb.position = pos
	bomb.from_player = by_who
	get_node("../..").add_child(bomb)
puppet func stun():
	stunned = true
puppet func stun2():
	stunned2 = true
master func exploded(_by_who):
	if stunned:
		return
	rpc("stun") 
	stun() 
master func exploded2():
	if stunned2:
			return
	rpc("stun2") 
	stun2() 
#chat box
func _on_bomber_animation_finished():
	stunned = false

func _on_Hitbox_body_entered(body):
	#if body.is_in_group("enemy"):
		#var explosion_instance = explosion4.instance()
		#explosion_instance.position = get_global_position()
		#get_tree().get_root().add_child(explosion_instance)
	#	rpc("hit_by_damager", damage1)
	pass
func _on_dogy_animation_finished():
	if speed ==0:
		speed = 150
	stunned2 = false
