extends Control


export var nextButtonPath: NodePath

onready var nextButton: Button = get_node(nextButtonPath)


func open(time: String):
	$VBoxContainer/Time.text = time
	self.visible = true
	nextButton.grab_focus()


func _next_level():
	var currentLevel = int(get_tree().current_scene.filename.replace('.tscn', '').split('Level')[-1])
	var nextLevelResourceName = 'res://scenes/levels/Level' + str(currentLevel + 1) + '.tscn'
	if ResourceLoader.exists(nextLevelResourceName):
		print('Loading level ', currentLevel + 1, ': ', get_tree().change_scene(nextLevelResourceName))
	else:
		_load_menu()

func _restart_level():
	print('Reloading level: ', get_tree().reload_current_scene())

func _load_menu():
	print('Loading level menu: ', get_tree().change_scene('res://scenes/LevelMenu.tscn'))
