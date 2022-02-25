extends Control


export var restartButtonPath: NodePath

onready var restartButton: Button = get_node(restartButtonPath)


func _restart_level():
	var _result = get_tree().change_scene(get_tree().current_scene.filename)


func show():
	self.visible = true
	restartButton.grab_focus()
