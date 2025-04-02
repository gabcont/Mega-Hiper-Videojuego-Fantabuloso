extends Control

@export var personaje_1 : Personaje
@export var personaje_2 : Personaje

@onready var etiqueta_nombre_p1 : Label = %NombreP1
@onready var etiqueta_nombre_p2 : Label = %NombreP2

@onready var barra_vida_p1 : TextureProgressBar = get_node("BarraVida")
@onready var barra_vida_p2 : TextureProgressBar = get_node("BarraVida2")

@onready var barra_poder_p1 : TextureProgressBar = get_node("BarraVida/BarraPoder")
@onready var barra_poder_p2 : TextureProgressBar = get_node("BarraVida2/BarraPoder")

func _ready() -> void:
	barra_vida_p1.max_value = personaje_1.SALUD_MAXIMA
	barra_vida_p2.max_value = personaje_2.SALUD_MAXIMA

	barra_poder_p1.max_value = personaje_1.PODER_MAXIMO
	barra_poder_p2.max_value = personaje_2.PODER_MAXIMO

	etiqueta_nombre_p1.text = personaje_1.nombre_personaje
	etiqueta_nombre_p2.text = personaje_2.nombre_personaje

func actualizar_nombres() -> void:
	etiqueta_nombre_p1.text = personaje_1.nombre_personaje
	etiqueta_nombre_p2.text = personaje_2.nombre_personaje


func _process(_delta: float) -> void:
	barra_vida_p1.value = personaje_1.salud
	barra_vida_p2.value = personaje_2.salud

	barra_poder_p1.value = personaje_1.poder
	barra_poder_p2.value = personaje_2.poder
