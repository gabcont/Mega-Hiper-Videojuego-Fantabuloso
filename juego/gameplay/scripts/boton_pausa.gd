extends Button
@export var escena_destino : String
@onready var menu_pausa = $"../../.."

func restablecer_valores():
	menu_pausa.hide()
	get_tree().paused = false

func _on_pressed() -> void:
	restablecer_valores()
	if escena_destino:
		SceneLoader.load_scene(escena_destino)
	
