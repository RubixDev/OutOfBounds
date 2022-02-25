extends Control


export var continueButtonPath: NodePath

onready var continueButton: Button = get_node(continueButtonPath)
onready var deathScreen: Control = get_node('../DeathScreen')
onready var completeScreen: Control = get_node('../CompleteScreen')


func show():
	get_tree().paused = true
	self.visible = true
	continueButton.grab_focus()

func hide():
	self.visible = false
	get_tree().paused = false


func _input(event):
	if event.is_action_pressed('pause') && !deathScreen.visible && !completeScreen.visible:
		if self.visible:
			hide()
		else:
			show()

func _continue():
	hide()

func _restart_level():
	print('Reloading level: ', get_tree().change_scene(get_tree().current_scene.filename))
	get_tree().paused = false

func _load_menu():
	print('Loading level menu: ', get_tree().change_scene('res://scenes/LevelMenu.tscn'))
	get_tree().paused = false
