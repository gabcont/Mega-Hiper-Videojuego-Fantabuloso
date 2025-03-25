extends Button

@onready var escena_juego: PackedScene = preload("res://juego/gameplay/escenas/partida.tscn")
@onready var escena_menu: PackedScene = preload("res://menu/escenas/menus/menu_principal/menu_principal.tscn")

func _ready() -> void:
	pressed.connect(_on_button_pressed)

func _on_button_pressed() -> void:
	
	var destino_escena = escena_juego if text == "VOLVER A JUGAR" else escena_menu
	get_tree().change_scene_to_packed(destino_escena)
