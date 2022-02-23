src_dir = src/
main_scene = scenes/MainScene.tscn

run:
	cd $(src_dir) && godot $(main_scene)

debug:
	cd $(src_dir) && godot --no-window --export-debug linux

release: linux windows web

linux:
	cd $(src_dir) && godot --no-window --export linux
windows:
	cd $(src_dir) && godot --no-window --export windows
web:
	cd $(src_dir) && godot --no-window --export web
