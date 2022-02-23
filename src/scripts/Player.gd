extends KinematicBody2D

onready var collider: CollisionShape2D = get_node('Collider')
# onready var sprite: Sprite = get_node('Sprite')
onready var camera: Camera2D = get_node('Camera')

var maxVelocity = 600
var acceleration = 50
var gravity = 30
var jumpVelocity = 850
var groundFriction = 70
var airFriction = 12

var friction = groundFriction
var velocity = Vector2()


func _physics_process(_delta):
	# Movement
	if Input.is_action_pressed('move_left') && velocity.x >= -maxVelocity:
		velocity.x -= acceleration
		# sprite.flip_h = true
	if Input.is_action_pressed('move_right') && velocity.x <= maxVelocity:
		velocity.x += acceleration
		# sprite.flip_h = false
	if Input.is_action_just_pressed('jump') && is_on_floor():
		velocity.y -= jumpVelocity

	# Friction
	if !Input.is_action_pressed('move_left') && !Input.is_action_pressed('move_right'):
		if is_on_floor():
			friction = groundFriction
		else:
			friction = airFriction

		if velocity.x > friction:
			velocity.x -= friction
		elif velocity.x < -friction:
			velocity.x += friction
		elif (0 < velocity.x && velocity.x <= friction) || (-friction <= velocity.x && velocity.x < 0):
			velocity.x = 0

	# Gravity
	velocity.y += gravity

	# OOB
	if Input.is_action_just_pressed('go_oob'):
		collider.disabled = true
	if Input.is_action_just_released('go_oob'):
		collider.disabled = false

	# Death outside camera area
	var cameraCenter = camera.get_camera_screen_center()
	if self.position.y > cameraCenter.y + 300:
		reload_scene()
	elif self.position.y < cameraCenter.y - 300:
		reload_scene()
	elif self.position.x > cameraCenter.x + 512:
		reload_scene()
	elif self.position.x < cameraCenter.x - 512:
		reload_scene()

	velocity = move_and_slide(velocity, Vector2.UP, true)

func reload_scene():
	var _result = get_tree().change_scene(get_tree().current_scene.filename)
