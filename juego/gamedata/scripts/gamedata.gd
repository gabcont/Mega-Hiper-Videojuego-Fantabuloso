# GameData.gd
extends Node

var nombre_personaje_1: String = "Knuckles"
var nombre_personaje_2: String = "Kirby"
var escenario_seleccionado: String = "Caricuao"
var otra_variable: int = 0 # Si tienes alguna otra variable
var tiempo = 60

func _ready():
	print("Singleton GameData inicializado")
