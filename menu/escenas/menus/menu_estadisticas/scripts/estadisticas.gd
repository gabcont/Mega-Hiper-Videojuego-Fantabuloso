extends Control

@export var menu_principal : PackedScene

func segundos_a_hms_string(total_segundos):
	"""
	Convierte segundos a cadena, mostrando solo segundos si < 60,
	minutos:segundos si < 3600, y horas:minutos:segundos en caso contrario.

	Args:
		total_segundos (int): La cantidad total de segundos.

	Returns:
		String: Una cadena representando el tiempo.
	"""
	if total_segundos < 60:
		return str(total_segundos) + " segundos"
	elif total_segundos < 3600:
		var minutos = floor(total_segundos / 60)
		var segundos = total_segundos % 60
		return "%d:%02d" % [int(minutos), int(segundos)] + " minutos"
	else:
		var horas = floor(total_segundos / 3600)
		var segundos_restantes_despues_horas = total_segundos % 3600
		var minutos = floor(segundos_restantes_despues_horas / 60)
		var segundos = segundos_restantes_despues_horas % 60
		return "%d:%02d:%02d" % [int(horas), int(minutos), int(segundos)] + " horas"

func _ready() -> void:
	$Vacio.text = ""
	var db = Db.conectar_base()
	var partidas = db.select_rows("partida","id_usuario=%d" % [Db.usuario_id],["id_personaje_usado","id_personaje_enfrentado","victoria","duracion_en_sg"])
	if partidas.size() == 0:
		$Vacio.text = "Juegue partidas para acumular estadisticas"
	else:
		var contador_sg = 0
		var contador_victorias=0
		for i in range(partidas.size()):
			contador_sg+=partidas[i]["duracion_en_sg"]
			if partidas[i]["victoria"]:
				contador_victorias+=1
		$VBoxContainer/Usado.text = "Personaje favorito: Knuckles"
		$VBoxContainer/Enfrentado.text = "Personaje mas enfrentado: Kirby"
		$VBoxContainer/Tiempo.text = "Tiempo de juego: "+ segundos_a_hms_string(contador_sg)
		$VBoxContainer/Historial.text = "Victorias - Derrotas : %d - %d" % [contador_victorias,partidas.size()-contador_victorias]

func _on_button_pressed() -> void:
	SceneLoader.load_scene("res://menu/escenas/menus/menu_principal/menu_principal_con_animaciones.tscn")
	
