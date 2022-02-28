extends Control

export var LIGHT_THEME: bool = false
export var KEY: String
export var BUTTON: String
export var TOUCH_TEXTURE: Texture

const KEYBOARD_FRAMES = { "0": 0, "DONT_INCLUDE0": 1, "DONT_INCLUDE1": 2, "DONT_INCLUDE2": 3, "1": 4, "2": 5, "3": 6, "4": 7, "5": 8, "shift": 9, "6": 10, "7": 11, "8": 12, "9": 13, "a": 14, "alt": 15, "down": 16, "left": 17, "right": 18, "shift-alt": 19, "up": 20, "asterisk": 21, "b": 22, "backspace": 23, "backspace-alt": 24, "braceleft": 25, "braceright": 26, "c": 27, "capslock": 28, "backslash": 29, "command": 30, "control": 31, "d": 32, "kp period": 33, "e": 34, "kp 1": 35, "enter-alt": 36, "enter": 37, "kp enter": 38, "space": 39, "escape": 40, "f10": 41, "f11": 42, "f12": 43, "f1": 44, "f2": 45, "f3": 46, "f4": 47, "f5": 48, "t":  49, "f6": 50, "f7": 51, "f8": 52, "f9": 53, "f": 54, "g": 55, "h": 56, "kp 7": 57, "i": 58, "tab": 59, "kp 0": 60, "j": 61, "k": 62, "l": 63, "m": 64, "comma": 65, "period": 66, "minus": 67, "mouse_left": 68, "quoteleft": 69, "mouse_middle": 70, "mouse_wheel_up": 70, "mouse_wheel_down": 70, "mouse_wheel_left": 70, "mouse_wheel_right": 70, "mouse_right": 71, "mouse": 72, "n": 73, "numlock": 74, "o": 75, "p": 76, "pagedown": 77, "pageup": 78, "u": 79, "equal": 80, "kp add": 81, "printscreen": 82, "q": 83, "slash": 84, "apostrophe": 85, "r": 86, "s": 87, "semicolon": 88, "v": 89, "w": 90, "windows": 91, "x": 92, "y": 93, "z": 94 }
const KEYBOARD_FRAME_COLUMNS = 10
const DUALSHOCK_FRAMES = { "0": 1, "1": 0, "2": 9, "3": 19, "4": 8, "5": 15, "6": 10, "7": 16, "8": 12, "9": 18, "10": 4, "11": 13, "12": 7, "13": 3, "14": 5, "15": 6, "22": 14, "left-stick": 11, "right-stick": 17 }
const DUALSHOCK_FRAME_COLUMNS = 5
const XBOX_FRAMES = { "0": 0, "1": 1, "2": 9, "3": 14, "4": 8, "5": 15, "6": 10, "7": 16, "8": 12, "9": 18, "10": 4, "11": 13, "12": 7, "13": 3, "14": 5, "15": 6, "left-stick": 11, "right-stick": 17 }
const XBOX_FRAME_COLUMNS = 5

func _ready():
	$Touch.texture = TOUCH_TEXTURE
	update_contents(ControlTypeStorage.lastControllerType, ControlTypeStorage.lastControllerType, true)
	# warning-ignore:return_value_discarded
	ControlTypeStorage.connect('update_prompts', self, 'update_contents')

# func _update_prompt(controllerType, lastControllerType):
# 	update_contents(controllerType, lastControllerType)

func update_contents(controllerType, lastControllerType, force=false):
	if controllerType == lastControllerType && !force:
		return

	for child in self.get_children():
		child.visible = false

	var key: String
	var rect: TextureRect
	var frames: Dictionary
	var frame_columns: int

	match controllerType:
		ControlTypeStorage.ControllerType.KEYBOARD:
			key = KEY
			if LIGHT_THEME:
				rect = $KeyboardLight
			else:
				rect = $KeyboardDark
			frames = KEYBOARD_FRAMES
			frame_columns = KEYBOARD_FRAME_COLUMNS
		ControlTypeStorage.ControllerType.DUALSHOCK:
			key = BUTTON
			rect = $DualShock
			frames = DUALSHOCK_FRAMES
			frame_columns = DUALSHOCK_FRAME_COLUMNS
		ControlTypeStorage.ControllerType.XBOX:
			key = BUTTON
			rect = $XBox
			frames = XBOX_FRAMES
			frame_columns = XBOX_FRAME_COLUMNS
		ControlTypeStorage.ControllerType.TOUCH:
			$Touch.visible = true
			return

	if !(key in frames):
		printerr("Key '", KEY, "' is invalid")
		return
	var frame = frames[key]
	var x_offset = frame % frame_columns
	var y_offset = (frame - x_offset) / frame_columns
	rect.rect_position = Vector2(-(102 * x_offset), -(102 * y_offset))
	rect.visible = true
