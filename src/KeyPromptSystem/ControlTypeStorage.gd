extends Node

enum ControllerType {
	KEYBOARD,
	DUALSHOCK,
	XBOX,
	TOUCH,
}

signal update_prompts(controllerType, lastControllerType)

var controllerType = ControllerType.KEYBOARD
var lastControllerType = ControllerType.KEYBOARD

func _ready():
	Input.add_joy_mapping('03000000242f00009100000000010000,EasySMX ESM-9101,a:b0,b:b1,x:b2,y:b3,back:b6,guide:b8,start:b7,leftstick:b9,rightstick:b10,leftshoulder:b4,rightshoulder:b5,dpup:h0.1,dpdown:h0.4,dpleft:h0.8,dpright:h0.2,leftx:a0,lefty:a1,rightx:a3,righty:a4,lefttrigger:a2,righttrigger:a5,platform:Linux,', true)

func _input(event):
	var newControllerType
	if OS.has_touchscreen_ui_hint():
		newControllerType = ControllerType.TOUCH
	elif event is InputEventKey || event is InputEventMouse:
		newControllerType = ControllerType.KEYBOARD
	elif event is InputEventJoypadButton || event is InputEventJoypadMotion:
		if is_dualshock(Input.get_joy_name(Input.get_connected_joypads().find(event.device))):
			newControllerType = ControllerType.DUALSHOCK
		else:
			newControllerType = ControllerType.XBOX
		print(Input.get_joy_name(Input.get_connected_joypads().find(event.device)))
	else:
		return
	controllerType = newControllerType
	emit_signal('update_prompts', controllerType, lastControllerType)
	lastControllerType = controllerType

func is_dualshock(name: String) -> bool:
	var partials = [
		"ps1 controller",
		"ps2 controller",
		"ps3 controller",
		"ps4 controller",
		"ps5 controller",
		"playstation",
	]
	for partial in partials:
		if partial in name.to_lower():
			return true
	return false
