extends RigidBody2D

var direction = false
var strength = 0
onready var expl = preload("res://gameoffline2/Scene/explosion.tscn")
var ex
func _ready():
	$audio.play()
func init(d):
	direction =d
	
func throw(imp_vec):
	strength = imp_vec
	if direction==1:
		strength.x *=-1
		
	apply_impulse(Vector2.ZERO, strength)

func _on_Timer_timeout():
	explode_granade()
func explode_granade():
	$Timer.stop()
	sleeping = true
	ex = expl.instance()
	$Sprite.visible = false
	add_child(ex)
	ex.connect('exploded',self,'granade_exploded')

func granade_exploded():
	queue_free()
	
