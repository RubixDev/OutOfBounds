src_dir = src/
main_scene = scenes/MainScene.tscn

run:
	cd $(src_dir) && godot $(main_scene)

debug:
	cd $(src_dir) && godot --no-window --export-debug linux

release: linux windows web

linux:
	mkdir -p export/linux/
	cd $(src_dir) && godot --no-window --export linux
windows:
	mkdir -p export/windows/
	cd $(src_dir) && godot --no-window --export windows
web:
	mkdir -p export/web/
	cd $(src_dir) && godot --no-window --export web
android:
	mkdir -p export/android/
	cd $(src_dir) && godot --no-window --export-debug android
