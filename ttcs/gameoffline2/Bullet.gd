extends Area2D
var a
func _ready():
	#scale = Vector2(.1, .1)
	a = Tonghop.m

func _physics_process(delta):
	if a ==1:
		position.x +=10
		$Sprite.flip_h = false
	else:
		position.x -=10
		$Sprite.flip_h = true
