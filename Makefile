src_dir = src/
main_scene = scenes/LevelMenu.tscn

run:
	cd $(src_dir) && godot $(main_scene)

debug:
	cd $(src_dir) && godot --no-window --export-debug linux

release: linux windows web android
	cd export && tar -czvf all.tar.gz linux.tar.gz windows.tar.gz web.tar.gz android.tar.gz

linux:
	mkdir -p export/linux/
	cd $(src_dir) && godot --no-window --export linux
	cd export && tar -czvf linux.tar.gz linux/
windows:
	mkdir -p export/windows/
	cd $(src_dir) && godot --no-window --export windows
	cd export && tar -czvf windows.tar.gz windows/
web:
	mkdir -p export/web/
	cd $(src_dir) && godot --no-window --export web
	cd export && tar -czvf web.tar.gz web/
android:
	mkdir -p export/android/
	cd $(src_dir) && godot --no-window --export-debug android
	cd export && tar -czvf android.tar.gz android/
