extends Button

signal boton_presionado(nombre_boton)

func _on_pressed() -> void:
	emit_signal("boton_presionado", text)
