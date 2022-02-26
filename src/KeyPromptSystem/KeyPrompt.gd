extends HBoxContainer

export var KEYBOARD_DARK_TEXTURE: Texture
export var KEYBOARD_LIGHT_TEXTURE: Texture
export var PS4_TEXTURE: Texture
export var XBOX_TEXTURE: Texture
export var TEXT: String
export var LIGHT_THEME: bool = false

const KEYBOARD_FRAMES = { "0": 0, "DONT_INCLUDE0": 1, "DONT_INCLUDE1": 2, "DONT_INCLUDE2": 3, "1": 4, "2": 5, "3": 6, "4": 7, "5": 8, "shift": 9, "6": 10, "7": 11, "8": 12, "9": 13, "a": 14, "alt": 15, "down": 16, "left": 17, "right": 18, "shift-alt": 19, "up": 20, "asterisk": 21, "b": 22, "backspace": 23, "backspace-alt": 24, "braceleft": 25, "braceright": 26, "c": 27, "capslock": 28, "backslash": 29, "command": 30, "control": 31, "d": 32, "kp period": 33, "e": 34, "kp 1": 35, "enter-alt": 36, "enter": 37, "kp enter": 38, "space": 39, "escape": 40, "f10": 41, "f11": 42, "f12": 43, "f1": 44, "f2": 45, "f3": 46, "f4": 47, "f5": 48, "t":  49, "f6": 50, "f7": 51, "f8": 52, "f9": 53, "f": 54, "g": 55, "h": 56, "kp 7": 57, "i": 58, "tab": 59, "kp 0": 60, "j": 61, "k": 62, "l": 63, "m": 64, "comma": 65, "period": 66, "minus": 67, "mouse_left": 68, "quoteleft": 69, "mouse_middle": 70, "mouse_wheel_up": 70, "mouse_wheel_down": 70, "mouse_wheel_left": 70, "mouse_wheel_right": 70, "mouse_right": 71, "mouse": 72, "n": 73, "numlock": 74, "o": 75, "p": 76, "pagedown": 77, "pageup": 78, "u": 79, "equal": 80, "kp add": 81, "printscreen": 82, "q": 83, "slash": 84, "apostrophe": 85, "r": 86, "s": 87, "semicolon": 88, "v": 89, "w": 90, "windows": 91, "x": 92, "y": 93, "z": 94 }
const KEYBOARD_FRAME_COLUMNS = 10
const MOUSE_BUTTON_NAMES = [null, "mouse_left", "mouse_right", "mouse_middle", "mouse_wheel_up", "mouse_wheel_down", "mouse_wheel_left", "mouse_wheel_right"]
const PS4_FRAMES = { "0": 1, "1": 0, "2": 9, "3": 19, "4": 8, "5": 15, "6": 10, "7": 16, "8": 12, "9": 18, "10": 4, "11": 13, "12": 7, "13": 3, "14": 5, "15": 6, "22": 14, "left-stick": 11, "right-stick": 17 }
const PS4_FRAME_COLUMNS = 5
const XBOX_FRAMES = { "0": 0, "1": 1, "2": 9, "3": 14, "4": 8, "5": 15, "6": 10, "7": 16, "8": 12, "9": 18, "10": 4, "11": 13, "12": 7, "13": 3, "14": 5, "15": 6, "left-stick": 11, "right-stick": 17 }
const XBOX_FRAME_COLUMNS = 5

enum ControllerType {
	KEYBOARD,
	PS4,
	XBOX,
}

var lastControllerType = ControllerType.KEYBOARD
var textParts: Array = []

func _ready():
	var parts = TEXT.split('$')
	textParts.append(parts[0])
	parts.remove(0)
	for part in parts:
		var actionParts = part.split(' ', true, 1)
		textParts.append(actionParts[0])
		if actionParts.size() > 1:
			textParts.append(' ' + actionParts[1])

	update_contents(ControllerType.KEYBOARD, true)

func _input(event):
	var controllerType
	if event is InputEventKey || event is InputEventMouse:
		controllerType = ControllerType.KEYBOARD
	elif event is InputEventJoypadButton || event is InputEventJoypadMotion:
		if Input.get_joy_name(Input.get_connected_joypads().find(event.device)).to_lower() == "ps4 controller":
			controllerType = ControllerType.PS4
		else:
			controllerType = ControllerType.XBOX
	update_contents(controllerType)
	lastControllerType = controllerType

func update_contents(controllerType, force=false):
	if controllerType == lastControllerType && !force:
		return

	for child in self.get_children():
		child.queue_free()
	var partIndex = 0
	for part in textParts:

		if partIndex % 2 == 0:
			var label = Label.new()
			label.text = part
			self.add_child(label)
		else:
			var clips = []
			for input in InputMap.get_action_list(part):
				var sprite = TextureRect.new()

				if controllerType == ControllerType.KEYBOARD:
					var key_name: String
					var mouse_properties: InputEventMouseButton = null
					if input is InputEventKey:
						key_name = input.as_text().to_lower()
					elif input is InputEventMouseButton:
						mouse_properties = input
					else:
						continue

					if LIGHT_THEME:
						sprite.texture = KEYBOARD_LIGHT_TEXTURE
					else:
						sprite.texture = KEYBOARD_DARK_TEXTURE

					if mouse_properties != null:
						sprite.rect_position = get_frame_pos(KEYBOARD_FRAMES[MOUSE_BUTTON_NAMES[mouse_properties.button_index]], KEYBOARD_FRAME_COLUMNS)
					else:
						sprite.rect_position = get_frame_pos(KEYBOARD_FRAMES[key_name], KEYBOARD_FRAME_COLUMNS)
				else:
					var button_properties: InputEventJoypadButton = null
					var joystick_properties: InputEventJoypadMotion = null
					if input is InputEventJoypadButton:
						button_properties = input
					elif input is InputEventJoypadMotion:
						joystick_properties = input
					else:
						continue

					var frames: Dictionary
					var frame_columns: int
					if controllerType == ControllerType.PS4:
						frames = PS4_FRAMES
						frame_columns = PS4_FRAME_COLUMNS
						sprite.texture = PS4_TEXTURE
					else:
						frames = XBOX_FRAMES
						frame_columns = XBOX_FRAME_COLUMNS
						sprite.texture = XBOX_TEXTURE

					if joystick_properties != null:
						if joystick_properties.axis == 0 || joystick_properties.axis == 1:
							sprite.rect_position = get_frame_pos(frames['left-stick'], frame_columns)
						else:
							sprite.rect_position = get_frame_pos(frames['left-stick'], frame_columns)
					else:
						sprite.rect_position = get_frame_pos(frames[str(button_properties.button_index)], frame_columns)

				var clip = Control.new()
				clip.rect_clip_content = true
				clip.rect_size = Vector2(102, 102)
				clip.rect_min_size = Vector2(102, 102)
				clip.add_child(sprite)
				clips.append(clip)

			var clipIndex = 0
			for clip in clips:
				self.add_child(clip)
				if clipIndex != clips.size() - 1:
					var slash = Label.new()
					slash.text = '/'
					self.add_child(slash)
				clipIndex += 1

		partIndex += 1

func get_frame_pos(frame: int, columns: int) -> Vector2:
	var x_offset = frame % columns
	var y_offset = (frame - x_offset) / columns
	return Vector2(-(102 * x_offset), -(102 * y_offset))
