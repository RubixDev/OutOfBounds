extends Control

export var levelCount: int
export var levelButtonsGridPath: NodePath

onready var levelButtonsGrid = get_node(levelButtonsGridPath)


func _ready():
	for i in range(1, levelCount + 1):
		var button = Button.new()
		button.text = 'Level ' + str(i)
		button.rect_min_size.x = 300
		button.rect_min_size.y = 100
		button.connect('pressed', self, '_load_level', [i])
		levelButtonsGrid.add_child(button)
		if i == 1:
			button.grab_focus()

func _load_level(num):
	print('Loading level ', num, ': ', get_tree().change_scene('res://scenes/levels/Level' + str(num) + '.tscn'))

func _back():
	print('Loading main menu: ', get_tree().change_scene('res://scenes/MainMenu.tscn'))
