# GameData.gd
extends Node

var nombre_personaje_1: String = "Knuckles"
var nombre_personaje_2: String = "Kirby"
var escenario_seleccionado: String = "Caricuao"
var otra_variable: int = 0 # Si tienes alguna otra variable
var tiempo = 60 # para guadar el tiempo de partida en la bd correctamente
var input_p1 : String = "vacio"
var puede_recibir_input : bool
var salud_p1 : int

func _ready():
	print("Singleton GameData inicializado")
