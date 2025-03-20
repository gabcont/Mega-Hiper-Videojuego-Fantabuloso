extends Control

# Pre-carga la escena del menú de pausa
var menu_pausa_scene = preload("res://m_pausa/escenas/menu_pausa.tscn")

func _on_texture_button_pressed() -> void:

	# Instancia la escena del menú de pausa
	var menu_pausa = menu_pausa_scene.instantiate()
	# Añade el menú de pausa como hijo del nodo principal de la escena actual
	get_tree().root.add_child(menu_pausa)
	get_tree().paused = true  # Pausa el árbol	
