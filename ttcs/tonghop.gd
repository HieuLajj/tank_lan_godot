extends Node

var danban setget danbanset
var nhanvat = "" setget nhanvatset
puppet var puppet_nhanvat = "" setget puppet_nhanvat_set
var tennhanvat setget tennhanvatset

var kiemtramap =1
var kiemtraminigame=1
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var mm=1
# Called when the node enters the scene tree for the first time.
func hom()-> void:
	print("nguenlahef")
func danbanset(new_value)-> void:
	if get_tree().has_network_peer():
		if Global.alive_players[0].name == str(get_tree().get_network_unique_id()):
			danban =new_value
#	if get_tree().has_network_peer():
	#	if is_network_master():
	#		danban =new_value
#		if get_tree().get_network_unique_id():
			#area.get_parent().player_owner != int(name)
#			danban =new_value
#print(get_tree().get_network_unique_id())
	
func nhanvatset(new_value)-> void:
	nhanvat = new_value
	if get_tree().has_network_peer():
		if is_network_master():
			rset("puppet_nhanvat",nhanvat)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func puppet_nhanvat_set(new_value):
	puppet_nhanvat = new_value
	if get_tree().has_network_peer():
		if not is_network_master():
			nhanvat = puppet_nhanvat
#func set_hp(new_value):
#	#hp_set(String(hp))
#	hp = new_value
#	if get_tree().has_network_peer():
#		if is_network_master():
#			rset("puppet_hp",hp)

#func puppet_hp_set(new_value):
#	puppet_hp = new_value
#	if get_tree().has_network_peer():
#		if not is_network_master():
#			hp=puppet_hp
func tennhanvatset(new_value):
	tennhanvat = new_value
