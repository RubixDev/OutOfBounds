extends KinematicBody2D

onready var collider: CollisionShape2D = get_node('Collider')
onready var camera: Camera2D = get_node('Camera')
# onready var sprite: Sprite = get_node('Sprite')

export var initialJumpTimer = 0.2
export var initialGroundedTimer = 0.1
export var cameraOffset = 250

const CAMERA_WIDTH = 1920
const CAMERA_HEIGHT = 1080
const CAMERA_HALF_WIDTH = CAMERA_WIDTH / 2
const CAMERA_HALF_HEIGHT = CAMERA_HEIGHT / 2

const MAX_VELOCITY = CAMERA_HEIGHT * 0.8
const ACCELERATION = CAMERA_HEIGHT / 12
const GRAVITY = CAMERA_HEIGHT / 20
const JUMP_VELOCITY = CAMERA_HEIGHT * 1.4
const GROUND_FRICTION = ACCELERATION * 1.5
const AIR_FRICTION = ACCELERATION * 0.15

var friction = GROUND_FRICTION
var velocity = Vector2()
var jumpTimer = initialJumpTimer
var groundedTimer = initialGroundedTimer


func _ready():
	camera.offset.x = cameraOffset
	camera.limit_left -= cameraOffset
	camera.limit_right -= cameraOffset


func _physics_process(delta):
	# Movement
	if Input.is_action_pressed('move_left') && velocity.x >= -MAX_VELOCITY:
		velocity.x -= ACCELERATION
		# sprite.flip_h = true
	if Input.is_action_pressed('move_right') && velocity.x <= MAX_VELOCITY:
		velocity.x += ACCELERATION
		# sprite.flip_h = false

	# Jumping
	jumpTimer -= delta
	groundedTimer -= delta
	if Input.is_action_just_pressed('jump'):
		jumpTimer = initialJumpTimer
	if is_on_floor():
		groundedTimer = initialGroundedTimer
	if jumpTimer > 0 && groundedTimer > 0:
		velocity.y = -JUMP_VELOCITY
		jumpTimer = 0
		groundedTimer = 0
		if !Input.is_action_pressed('jump'):
			velocity.y *= 0.6
	if Input.is_action_just_released('jump') && velocity.y < 0:
		velocity.y *= 0.5

	# Friction
	if !Input.is_action_pressed('move_left') && !Input.is_action_pressed('move_right'):
		if is_on_floor():
			friction = GROUND_FRICTION
		else:
			friction = AIR_FRICTION

		if velocity.x > friction:
			velocity.x -= friction
		elif velocity.x < -friction:
			velocity.x += friction
		elif (0 < velocity.x && velocity.x <= friction) || (-friction <= velocity.x && velocity.x < 0):
			velocity.x = 0

	# Gravity
	velocity.y += GRAVITY

	# OOB
	if Input.is_action_just_pressed('go_oob'):
		collider.disabled = true
	if Input.is_action_just_released('go_oob'):
		collider.disabled = false

	# Death outside camera area
	var cameraCenter = camera.get_camera_screen_center()
	if self.position.y > cameraCenter.y + CAMERA_HALF_HEIGHT:
		reload_scene()
	elif self.position.y < cameraCenter.y - CAMERA_HALF_HEIGHT:
		reload_scene()
	elif self.position.x > cameraCenter.x + CAMERA_HALF_WIDTH:
		reload_scene()
	elif self.position.x < cameraCenter.x - CAMERA_HALF_WIDTH:
		reload_scene()

	velocity = move_and_slide(velocity, Vector2.UP, true)

func reload_scene():
	var _result = get_tree().change_scene(get_tree().current_scene.filename)
