# GameData.gd
extends Node

var path_partida : String = "res://juego/gameplay/escenas/partida.tscn"

var nombre_personaje_1: String = "Knuckles"
var nombre_personaje_2: String = "Kirby"
var escenario_seleccionado: String = "Caricuao"

var otra_variable: int = 0 # Si tienes alguna otra variable
var tiempo = 60 # para guadar el tiempo de partida en la bd correctamente

var input_p1 : String = "vacio"
var salud_p1 : int

var dificultad_ia : String = "dificil"

var modo_juego_actual: ModoJuego = ModoJuego.VS_JUGADOR
var partida_queue : Array[Array] = [["Goku", "Gojo", "dbz"]]
# Partida = {"Sonic", "Gojo", "Caricuao"}  
# siguiendo formato {"nombrePersonaje1", "nombrePersonaje2", "nombreEscenario"}

enum ModoJuego {
	VS_JUGADOR, # 0
	VS_IA, # 1
	ARCADE # 2
}

func _ready():
	print("Singleton GameData inicializado")

func agregar_a_partida_queue(personaje_1 : String, personaje_2 : String, escenario : String) -> void:
	partida_queue.push_back([personaje_1, personaje_2, escenario])

func limpiar_queue() -> void:
	partida_queue.clear()

func obtener_partida_actual() -> Array:
	return partida_queue.front()

func siguiente_partida() -> void:
	partida_queue.pop_front()

func queue_partida_vacio() -> bool:
	return partida_queue.is_empty()
