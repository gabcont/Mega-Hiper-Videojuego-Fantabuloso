# GameData.gd
extends Node

var nombre_personaje_1: String = "Knuckles"
var nombre_personaje_2: String = "Kirby"
var escenario_seleccionado: String = "Caricuao"
var otra_variable: int = 0 # Si tienes alguna otra variable
var tiempo = 60

enum ModoJuego {
	VS_JUGADOR, # 0
	VS_IA, # 1
	ARCADE # 2
}

var modo_juego_actual: ModoJuego 
var torre_arcade_seleccionada: int = -1
var personajes_torre: Dictionary = {}
var escenarios_torre: Dictionary = {}

func _ready():
	print("Singleton GameData inicializado")
	configurar_datos_torres()

func configurar_datos_torres() -> void:
	# Anime 1
	personajes_torre[0] = ["luffy", "vegeta", "goku"]
	escenarios_torre[0] = ["luffy2.tscn", "dbz.tscn", "dbz.tscn"]
	
	# Anime 2
	personajes_torre[1] = ["naruto", "itadori", "gojo"]
	escenarios_torre[1] = ["naruto.tscn", "jujutsu.tscn", "jujutsu.tscn"]
	
	# Videojuegos 1
	personajes_torre[2] = ["kirby", "shadow", "sonic"]
	escenarios_torre[2] = ["kirby.tscn", "sonic.tscn", "sonic.tscn"]
	
	# Videojuegos 2
	personajes_torre[3] = ["sans", "knuckles", "metal sonic"]
	escenarios_torre[3] = ["sans.tscn", "sonic.tscn", "sonic.tscn"]

func seleccionar_modo_arcade(id_torre: int) -> void:
	torre_arcade_seleccionada = id_torre
	print("Torre seleccionada: ", id_torre)
	print("Personajes disponibles: ", personajes_torre[id_torre])
	print("Escenarios disponibles: ", escenarios_torre[id_torre])

func obtener_personaje_actual(nivel: int) -> String:
	if torre_arcade_seleccionada != -1:
		return personajes_torre[torre_arcade_seleccionada][nivel]
	else:
		return ""

func obtener_escenario_actual(nivel: int) -> String:
	if torre_arcade_seleccionada != -1:
		return escenarios_torre[torre_arcade_seleccionada][nivel]
	else:
		return ""
