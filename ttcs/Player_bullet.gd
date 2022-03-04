extends Sprite


var velocity = Vector2(1,0)
var player_rotation

export(int) var speed = 1100
export(int) var damage = 25

puppet var puppet_position setget puppet_position_set
puppet var puppet_velocity = Vector2(0,0)
puppet var puppet_rotation = 0

#puppet var puppet_tankdohoa setget puppet_tankdohoa_set
#var tankdohoa setget  tankdohoa_set
var bulletdohoa setget bulletdohoa_set
puppet var puppet_bulletdohoa setget puppet_bulletdohoa_set

onready var initial_position = global_position
var player_owner = 0

var explosion = preload("res://hieuungsung.tscn")
var explosion2 = preload("res://hieuungsung.tscn")
var explosion3 = preload("res://hieuungtuyet.tscn")


var dando =null

var cb =3
var dannhunao 
func _ready() -> void:
	visible = false
	yield(get_tree(), "idle_frame")
	if get_tree().has_network_peer():
		if is_network_master():
			velocity = velocity.rotated(player_rotation)
			rotation = player_rotation
			rset("puppet_velocity", velocity)
			rset("puppet_rotation", rotation)
			rset("puppet_position", global_position)
	visible = true
	
	#bulletdohoa_set("dannangcap")
	bulletdohoa_set(Tonghop.danban)
func _process(delta: float)-> void:
	if get_tree().has_network_peer():
		if is_network_master():
			global_position += velocity * speed *delta
		else:
			rotation = puppet_rotation
			global_position += puppet_velocity *speed *delta
func puppet_position_set(new_value) -> void:
	puppet_position = new_value
	global_position = puppet_position

sync func destroy() -> void:
	queue_free()	


func _on_Destroy_timer_timeout():
	if get_tree().has_network_peer():
		if get_tree().is_network_server():
			rpc("destroy")


func _on_Hitbox_body_entered(body):
	if body.is_in_group("cayto2"):
		var explosion_instance = explosion.instance()
		explosion_instance.position = get_global_position()
		get_tree().get_root().add_child(explosion_instance)
		queue_free()
	elif body.is_in_group("iceice"):
		var explosion_instance = explosion3.instance()
		explosion_instance.position = get_global_position()
		get_tree().get_root().add_child(explosion_instance)
		cb=2
		queue_free()
#	elif body.is_in_group("nguoichoi"):
#		var explosion_instance = explosion2.instance()
#		explosion_instance.position = get_global_position()
#		get_tree().get_root().add_child(explosion_instance)
#	else:
#		pass
func bulletdohoa_set(new_value)-> void:
	bulletdohoa = new_value
	if get_tree().has_network_peer():
		if is_network_master():
		#	chuyendoitrangthaidan(bulletdohoa)
			rset("puppet_bulletdohoa",bulletdohoa)
func puppet_bulletdohoa_set(new_value)-> void:
	puppet_bulletdohoa = new_value
	if get_tree().has_network_peer():
		if not is_network_master():
			chuyendoitrangthaidan(puppet_bulletdohoa)
	
func chuyendoitrangthaidan(a) -> void:
	#if a=="dannangcap":
		#dando =preload("res://mapPack/dannay/Fmothai.png")
	#else:
		#dando = preload("res://mapPack/dannay/tankfire.png")
	#$Sprite.set_texture(dando)
	pass


func _on_Hitbox_area_entered(area):
	if area.is_in_group("thunder"):
		queue_free()
