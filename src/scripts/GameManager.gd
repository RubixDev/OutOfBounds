extends Node

var completion_times = {}
var config := ConfigFile.new()
const CONFIG_PATH = 'user://savegame.cfg'

func _ready():
    if config.load(CONFIG_PATH) != OK:
        return
    for level in config.get_section_keys("Times"):
        completion_times[level] = config.get_value("Times", level)
    print('Loaded completion times: ', completion_times)

func save_time(level: String, time: int):
    if get_time(level) <= time:
        return
    completion_times[level] = time
    config.set_value("Times", level, time)
    print('Saving game state: ', config.save(CONFIG_PATH))

func get_time(level: String) -> int:
    if level in completion_times:
        return completion_times[level]
    return 9999999

func get_time_str(level: String) -> String:
    return time_as_str(get_time(level))

func time_as_str(time: int) -> String:
    var time_str: String = str(time).pad_zeros(7)
    if time_str.length() > 7:
        return '-'
    return time_str.substr(0, 2) + ':' + time_str.substr(2, 2) + '.' + time_str.substr(4)
