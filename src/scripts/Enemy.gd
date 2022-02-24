extends KinematicBody2D

var CAMERA_WIDTH = ProjectSettings.get_setting('display/window/size/width')
var CAMERA_HEIGHT = ProjectSettings.get_setting('display/window/size/height')
var GRAVITY = CAMERA_HEIGHT / 20
const SPEED = 200

var velocity = Vector2()
var facing_right = false

signal touched_player(enemy)

func _physics_process(_delta):
	if is_on_wall():
		facing_right = !facing_right

	if facing_right:
		velocity.x = SPEED
	else:
		velocity.x = -SPEED
	velocity.y += GRAVITY

	velocity = move_and_slide(velocity, Vector2.UP)

	for i in get_slide_count():
		if get_slide_collision(i).collider.name == 'Player':
			emit_signal('touched_player', self)
