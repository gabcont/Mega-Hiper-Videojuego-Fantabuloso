extends Control

@export var personaje_1 : Personaje
@export var personaje_2 : Personaje

@onready var etiqueta_nombre_p1 : Label = get_node("BarraJugador1/Nombre")
@onready var etiqueta_nombre_p2 : Label = get_node("BarraJugador2/Nombre")

@onready var barra_vida_p1 : TextureProgressBar = get_node("BarraJugador1/HBoxContainer/HBoxContainer/BarraVida")
@onready var barra_vida_p2 : TextureProgressBar = get_node("BarraJugador2/HBoxContainer/HBoxContainer/BarraVida")

func _ready() -> void:
    barra_vida_p1.max_value = personaje_1.SALUD_MAXIMA
    barra_vida_p2.max_value = personaje_2.SALUD_MAXIMA

    etiqueta_nombre_p1.text = personaje_1.nombre_personaje
    etiqueta_nombre_p2.text = personaje_2.nombre_personaje

func _process(_delta: float) -> void:
    barra_vida_p1.value = personaje_1.salud
    barra_vida_p2.value = personaje_2.salud