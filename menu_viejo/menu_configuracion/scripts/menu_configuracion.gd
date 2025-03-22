extends Control

func _ready():
	pass

func volumen(bus_index, value):
	# Escalar el valor del slider (0-100) a un rango lineal (0.0-1.0)
	var scaled_value = value / 100.0
	var db_value = linear_to_db(scaled_value)
	AudioServer.set_bus_volume_db(bus_index, db_value)

func _on_Slider_musica_value_changed(value):
	volumen(0, value)

func _on_atras_pressed() -> void:
	get_tree().change_scene_to_file("res://menu-principal/escenas/menu_principal.tscn")
