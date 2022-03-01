extends Control


export var restartButtonPath: NodePath

onready var restartButton: Button = get_node(restartButtonPath)


func show():
	self.visible = true
	restartButton.grab_focus()


func _restart_level():
	print('Reloading level: ', get_tree().reload_current_scene())


func _load_menu():
	print('Loading level menu: ', get_tree().change_scene('res://scenes/LevelMenu.tscn'))
