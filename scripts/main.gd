extends Node2D

@onready var personaje = get_node("Personaje")

func _ready() -> void:
	$BotonAtaque1.connect("boton_presionado", _on_boton_presionado)
	$BotonAtaque2.connect("boton_presionado", _on_boton_presionado)
	$BotonAtaque3.connect("boton_presionado", _on_boton_presionado)
	$BotonAtaque4.connect("boton_presionado", _on_boton_presionado)

func _on_boton_presionado(nombre_boton : String):
	personaje.play_animacion(nombre_boton)
