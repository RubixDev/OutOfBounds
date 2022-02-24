extends KinematicBody2D

onready var collider: CollisionShape2D = get_node('Collider')
onready var camera: Camera2D = get_node('Camera')
onready var deathScreen: Control = get_node('/root/MainScene/CanvasLayer/DeathScreen')
# onready var sprite: Sprite = get_node('Sprite')

export var initialJumpTimer = 0.2
export var initialGroundedTimer = 0.1
export var cameraOffset = 250

var CAMERA_WIDTH = ProjectSettings.get_setting('display/window/size/width')
var CAMERA_HEIGHT = ProjectSettings.get_setting('display/window/size/height')
var CAMERA_HALF_WIDTH = CAMERA_WIDTH / 2.0
var CAMERA_HALF_HEIGHT = CAMERA_HEIGHT / 2.0

var MAX_VELOCITY = CAMERA_HEIGHT * 0.8
var ACCELERATION = CAMERA_HEIGHT / 12
var GRAVITY = CAMERA_HEIGHT / 20
var JUMP_VELOCITY = CAMERA_HEIGHT * 1.4
var GROUND_FRICTION = ACCELERATION * 1.5
var AIR_FRICTION = ACCELERATION * 0.15

var friction = GROUND_FRICTION
var velocity = Vector2()
var jumpTimer = 0
var groundedTimer = 0
var isDead = false


func _ready():
	camera.offset.x = cameraOffset
	camera.limit_left -= cameraOffset
	camera.limit_right -= cameraOffset

	for enemy in get_tree().get_nodes_in_group('Enemy'):
		enemy.connect('touched_player', self, '_touched_enemy')

func _touched_enemy(_enemy):
	handle_death(true)

func _physics_process(delta):
	# Gravity
	velocity.y += GRAVITY

	# Stop here if dead
	if isDead:
		velocity.x = 0
		velocity = move_and_slide(velocity, Vector2.UP, true)
		return

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

	# OOB
	if Input.is_action_just_pressed('go_oob'):
		collider.disabled = true
	if Input.is_action_just_released('go_oob'):
		collider.disabled = false

	# Death outside camera area
	var cameraCenter = camera.get_camera_screen_center()
	if self.position.y > cameraCenter.y + CAMERA_HALF_HEIGHT:
		handle_death(false)
	elif self.position.y < cameraCenter.y - CAMERA_HALF_HEIGHT:
		handle_death(false)
	elif self.position.x > cameraCenter.x + CAMERA_HALF_WIDTH:
		handle_death(false)
	elif self.position.x < cameraCenter.x - CAMERA_HALF_WIDTH:
		handle_death(false)

	# Enemy collison
	for i in get_slide_count():
		var collided = get_slide_collision(i).collider
		if collided is Node && collided.is_in_group('Enemy'):
			handle_death(true)

	# Apply movement
	velocity = move_and_slide(velocity, Vector2.UP, true)

func handle_death(animate: bool):
	if isDead:
		return
	collider.disabled = true
	deathScreen.visible = true
	deathScreen.get_node('MarginContainer/VBoxContainer/CenterContainer/VBoxContainer/RestartButton').grab_focus()
	velocity.x = 0
	if animate:
		velocity.y = -(CAMERA_HEIGHT * 0.75)
	isDead = true
