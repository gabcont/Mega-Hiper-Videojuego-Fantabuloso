extends Control


func _on_jugar_pressed() -> void:
	get_tree().change_scene_to_file("res://escenas/menu_jugador.tscn")


func _on_configuracion_pressed() -> void:
	get_tree().change_scene_to_file("res://escenas/menu_configuracion.tscn")


func _on_instrucciones_pressed() -> void:
	get_tree().change_scene_to_file("res://escenas/instrucciones.tscn")


func _on_salir_pressed():
	get_tree().quit()


func _on_creditos_pressed() -> void:
	get_tree().change_scene_to_file("res://escenas/creditos.tscn")
