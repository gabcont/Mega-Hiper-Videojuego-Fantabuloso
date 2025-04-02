extends MainMenu

@export var escena_estadisticas : String


func _on_estadisticas_pressed() -> void:
	SceneLoader.load_scene(escena_estadisticas)
	
