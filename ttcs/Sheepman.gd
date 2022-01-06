extends KinematicBody2D

enum {
	DUNGYEN,
	TIENLEN
}
var m: int =1
var knockback = Vector2.ZERO
var rng = RandomNumberGenerator.new()
var trangthai = DUNGYEN
var huong:Vector2 = Vector2.ZERO
var tocdo:int = 200
var danhsach_muctieu:Array =[]
onready var anim_play = $AnimationTree.get("parameters/playback")

func _ready():
	$AnimationTree.active = true
func _process(delta):
	match trangthai:
		DUNGYEN:
			anim_play.travel("idle")
			huong = Vector2.ZERO
			tim_kethu()
		TIENLEN:
			if tim_kethu() == true:
				if global_position.distance_to(danhsach_muctieu[0].global_position) < 300 :
					#print(global_position.distance_to(danhsach_muctieu[0].global_position))
					anim_play.travel("go")
					huong = global_position.direction_to(danhsach_muctieu[0].global_position)
				else:
					trangthai = DUNGYEN
					danhsach_muctieu.clear()
				
				
			else:
				trangthai = DUNGYEN
			


func _physics_process(delta):
	if m==1:
		var chuyenhuong = huong * tocdo * delta
		move_and_collide(chuyenhuong)
	if m==2:
		knockback = knockback.move_toward(Vector2.ZERO, 200* delta)
		knockback = move_and_slide(knockback)
		m=1

func tim_kethu():
	if !danhsach_muctieu.empty():
		trangthai = TIENLEN
		return true
	else:
		return false
func _on_Hurtbox_area_entered(area):
	if area.is_in_group("Player_damager"):
		m=2
		rng.randomize()
		var my_random_number = rng.randi_range(1,4)
		match my_random_number:
			1:
				knockback = Vector2.UP * 10000
			2:
				knockback = Vector2.LEFT * 10000
			3:
				knockback = Vector2.RIGHT * 10000
			4: 
				knockback = Vector2.DOWN * 10000


func _on_truytung_body_entered(body):
	if body.is_in_group("Player") :
		danhsach_muctieu.append(body)
	pass
