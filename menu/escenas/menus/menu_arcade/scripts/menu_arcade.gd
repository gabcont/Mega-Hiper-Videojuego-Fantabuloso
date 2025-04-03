extends Node2D

var torre_1 : Array[Array] = [
	["Luffy", "luffy"],
	["Vegeta", "dbz"],
	["Goku", "dbz"]
]

var torre_2 : Array[Array] = [
	["Naruto", "naruto"],
	["Sukuna", "jujutsu"],
	["Gojo", "jujutsu"]
]

var torre_3 : Array[Array] = [
	["Kirby", "kirby"],
	["Shadow", "sonic"],
	["Sonic", "sonic"]
]

var torre_4 : Array[Array] = [
	["Metal Sonic", "sonic"],
	["Knuckles", "sonic"],
	["Sans", "sans"]
]

var torre_seleccionada

func _on_atras_pressed() -> void:
	SceneLoader.load_scene("res://menu/arcade/menu_pjs/scripts/arcade_seleccion.gd")

func _on_anime_1_pressed() -> void:
	torre_seleccionada = torre_1
	cargar_partidas_y_cambiar_escena()

func _on_anime_2_pressed() -> void:
	torre_seleccionada = torre_2
	cargar_partidas_y_cambiar_escena()

func _on_videojuegos_1_pressed() -> void:
	torre_seleccionada = torre_3
	cargar_partidas_y_cambiar_escena()

func _on_videojuegos_2_pressed() -> void:
	torre_seleccionada = torre_4
	cargar_partidas_y_cambiar_escena()

func cargar_partidas_y_cambiar_escena() -> void:
	ConfigPartida.limpiar_queue()
	for partida in torre_seleccionada:
		ConfigPartida.agregar_a_partida_queue(ConfigPartida.nombre_personaje_1, partida[0], partida[1])
	SceneLoader.load_scene(ConfigPartida.path_partida)
