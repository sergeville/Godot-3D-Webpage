extends Control
## Boot scene: lightweight 2D loading screen shown while the 3D main
## environment streams in. Uses threaded loading with the default
## use_sub_threads=false so it also works in web builds without thread support.

const MAIN_SCENE := "res://scenes/main/main_environment.tscn"

@onready var progress_bar: ProgressBar = $CenterContainer/VBoxContainer/ProgressBar


func _ready() -> void:
	ResourceLoader.load_threaded_request(MAIN_SCENE)


func _process(_delta: float) -> void:
	var progress: Array = []
	var status := ResourceLoader.load_threaded_get_status(MAIN_SCENE, progress)
	match status:
		ResourceLoader.THREAD_LOAD_IN_PROGRESS:
			progress_bar.value = progress[0] * 100.0
		ResourceLoader.THREAD_LOAD_LOADED:
			progress_bar.value = 100.0
			set_process(false)
			var scene: PackedScene = ResourceLoader.load_threaded_get(MAIN_SCENE)
			get_tree().change_scene_to_packed.call_deferred(scene)
		_:
			set_process(false)
			push_error("Failed to load main scene: %s" % MAIN_SCENE)
