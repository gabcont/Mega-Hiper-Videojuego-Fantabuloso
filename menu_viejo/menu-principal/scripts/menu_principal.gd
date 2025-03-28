extends Control


func _on_jugar_pressed() -> void:
	Transicion.transicion()
	await Transicion.on_transition_finished
	get_tree().change_scene_to_file("res://gameplay/escenas/partida.tscn")


func _on_configuracion_pressed() -> void:

	get_tree().change_scene_to_file("res://menu_configuracion/escenas/menu_configuracion.tscn")


func _on_instrucciones_pressed() -> void:
	get_tree().change_scene_to_file("res://m_instrucciones/escenas/instrucciones.tscn")


func _on_salir_pressed():
	get_tree().quit()


func _on_creditos_pressed() -> void:
	get_tree().change_scene_to_file("res://m_creditos/escenas/creditos.tscn")
