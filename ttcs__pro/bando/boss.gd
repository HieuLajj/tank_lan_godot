extends KinematicBody2D

enum{
	DUNGYEN,
	TIENLEN,
	TANCONG,
	LANGTHANG
}
var m: int =1
var knockback = Vector2.ZERO
var rng = RandomNumberGenerator.new()
var trangthai = DUNGYEN

var huong:Vector2 = Vector2.ZERO

var tocdo:int = 200
var danhsach_muctieu:Array =[]
onready var anim_play =$AnimationTree.get("parameters/playback")
var init_scale = scale.x
func _ready():
	$AnimationTree.active = true
func _process(delta):
	if huong.x>0:
		scale.x = init_scale * sign(scale.y)
	else:
		scale.x = -init_scale * sign(scale.y)
	match trangthai:
		DUNGYEN:
			if tim_kethu() == false:
				anim_play.travel("idle2")
				huong = Vector2.ZERO
			tim_kethu()
			if $Timer.time_left ==0:
				trangthai =chuyendoi_trangthai([DUNGYEN,LANGTHANG])
				$Timer.start()
			if $audio4.playing == true:
				$audio4.playing = false
		TANCONG:
			if tim_kethu() == true:
				if global_position.distance_to(danhsach_muctieu[0].global_position) < 400 :
					anim_play.travel("attack")
				#	$audio4.play()
					if $audio4.playing == false:
						$audio4.play()
					huong = global_position.direction_to(danhsach_muctieu[0].global_position)
				else:
					trangthai = DUNGYEN
					danhsach_muctieu.clear()
			else:
				trangthai = DUNGYEN
		LANGTHANG:
			if $Timer.time_left ==0:
				trangthai =chuyendoi_trangthai([DUNGYEN,LANGTHANG])
				$Timer.start()
			huong = global_position.direction_to(vitri_muctieu)
			anim_play.travel("go")
			if global_position.distance_to(vitri_muctieu) <5:
				trangthai =chuyendoi_trangthai([DUNGYEN,LANGTHANG])
				$Timer.start()
			if $audio4.playing == true:
				$audio4.playing = false

func _physics_process(delta):
	var chuyenhuong 
	
	chuyenhuong = Vector2(0,0)
	
	if get_tree().has_network_peer():
		if is_network_master():
			chuyenhuong = huong * tocdo * delta
		else:
			chuyenhuong = huong * tocdo * delta
		#da sua loi o day 1 lan
		move_and_collide(chuyenhuong)
func tim_kethu():
	if !danhsach_muctieu.empty():
		trangthai = TANCONG
		return true
	else:
		return false
onready var vitri_batdau = global_position
onready var vitri_muctieu = global_position

func capnhat_vitri():
	var muctieu_vector = Vector2( rand_range(-100,100), rand_range(-100,100))
	#var muctieu_vector = Vector2( 1000, 1000)
	vitri_muctieu = vitri_batdau + muctieu_vector
	
func chuyendoi_trangthai(danhsach: Array):
	danhsach.shuffle()
	return danhsach.pop_front()


func _on_truytung2_body_entered(body):
	pass
	if body.is_in_group("Player") :
		danhsach_muctieu.append(body)

func _on_Timer_timeout():
	capnhat_vitri()
	pass # Replace with function body.

