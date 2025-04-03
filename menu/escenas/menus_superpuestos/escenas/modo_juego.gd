extends Control

@export var path_escena_juego : String = "res://menu/escenas/menus/menu_personajes/escenas/menu_personajes.tscn"
@export var path_escena_arcade : String = "res://menu/escenas/menus/menu_arcade/escenas/seleccion_personaje_arcade.tscn"

func _ready() -> void:
	ConfigPartida.limpiar_queue()

func _on_arcade_pressed() -> void:
	ConfigPartida.set_modo_juego(ConfigPartida.ModoJuego.ARCADE)
	SceneLoader.load_scene(path_escena_arcade)
	

func _on_pvcpu_pressed() -> void:
	ConfigPartida.set_modo_juego(ConfigPartida.ModoJuego.VS_IA)
	SceneLoader.load_scene(path_escena_juego)

func _on_pvp_pressed() -> void:
	ConfigPartida.set_modo_juego(ConfigPartida.ModoJuego.VS_JUGADOR)
	SceneLoader.load_scene(path_escena_juego)
