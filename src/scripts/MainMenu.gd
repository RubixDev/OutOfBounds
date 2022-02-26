extends Control

export var playButtonPath: NodePath

onready var playButton = get_node(playButtonPath)


func _ready():
	playButton.grab_focus()

func _play():
	print('Opening level menu: ', get_tree().change_scene('res://scenes/LevelMenu.tscn'))

func _exit():
	get_tree().quit()
