extends Node2D

func _on_atras_pressed() -> void:
	SceneLoader.load_scene("res://menu/arcade/menu_pjs/scripts/arcade_seleccion.gd")

func _on_anime_1_pressed() -> void:
	ConfigPartida.seleccionar_modo_arcade(0)
	print("Torre seleccionada:", ConfigPartida.torre_arcade_seleccionada)
	print("Personajes disponibles:", ConfigPartida.personajes_torre[0])
	# SceneLoader.load_scene("res://menu/escenas/arcade/menu_pjs/escenas/arcade_seleccion.tscn")

func _on_anime_2_pressed() -> void:
	ConfigPartida.seleccionar_modo_arcade(1)
	print("Torre seleccionada:", ConfigPartida.torre_arcade_seleccionada)
	print("Personajes disponibles:", ConfigPartida.personajes_torre[1])
	# SceneLoader.load_scene("res://menu/escenas/arcade/menu_pjs/escenas/arcade_seleccion.tscn")

func _on_videojuegos_1_pressed() -> void:
	ConfigPartida.seleccionar_modo_arcade(2)
	print("Torre seleccionada:", ConfigPartida.torre_arcade_seleccionada)
	print("Personajes disponibles:", ConfigPartida.personajes_torre[2])
	# SceneLoader.load_scene("res://menu/escenas/arcade/menu_pjs/escenas/arcade_seleccion.tscn")

func _on_videojuegos_2_pressed() -> void:
	ConfigPartida.seleccionar_modo_arcade(3)
	print("Torre seleccionada:", ConfigPartida.torre_arcade_seleccionada)
	print("Personajes disponibles:", ConfigPartida.personajes_torre[3])
	# SceneLoader.load_scene("res://menu/escenas/arcade/menu_pjs/escenas/arcade_seleccion.tscn")
