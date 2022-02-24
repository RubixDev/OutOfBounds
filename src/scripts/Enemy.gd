extends KinematicBody2D

var CAMERA_WIDTH = ProjectSettings.get_setting('display/window/size/width')
var CAMERA_HEIGHT = ProjectSettings.get_setting('display/window/size/height')
var GRAVITY = CAMERA_HEIGHT / 20

var velocity = Vector2()

signal touched_player(enemy)

func _physics_process(_delta):
	velocity.x = -200
	velocity.y += GRAVITY
	velocity = move_and_slide(velocity)
	for i in get_slide_count():
		if get_slide_collision(i).collider.name == 'Player':
			emit_signal('touched_player', self)
