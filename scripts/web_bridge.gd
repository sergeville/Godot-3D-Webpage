extends Node
## Autoload: browser interop via JavaScriptBridge.
## Every call is guarded with OS.has_feature("web") so the project runs
## unchanged in the editor and native builds.

func _ready() -> void:
	js_log("Godot 3D site successfully loaded!")


func js_log(message: String) -> void:
	if OS.has_feature("web"):
		JavaScriptBridge.eval("console.log(%s)" % JSON.stringify(message))


## Send an arbitrary payload to the parent HTML frame (postMessage).
func post_to_parent(payload: Dictionary) -> void:
	if OS.has_feature("web"):
		JavaScriptBridge.eval("window.parent.postMessage(%s, '*')" % JSON.stringify(payload))
