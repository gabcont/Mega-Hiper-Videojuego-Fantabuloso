extends MainMenu

@export var escena_estadisticas : PackedScene


func _on_estadisticas_pressed() -> void:
	Transicion.transicion()
	await Transicion.on_transition_finished
	get_tree().change_scene_to_packed(escena_estadisticas)
	
