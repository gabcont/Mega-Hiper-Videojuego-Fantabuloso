extends Control


func _on_finalizar_pressed() -> void:
	print("se dio click")
	get_tree().change_scene_to_file("res://menu-principal/escenas/menu_principal.tscn")
	self.queue_free() 
	
func _on_continuar_pressed() -> void:
	print("Reanudando el juego")
	get_tree().paused = false	
	self.queue_free() 

func _on_h_slider_value_changed(value: float) -> void:
	# Ajusta el volumen del bus "Música"
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Musica"), value)
