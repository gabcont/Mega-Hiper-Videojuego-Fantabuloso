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
		
func obtener_id_mas_frecuente(arr_de_diccionarios: Array,nombre) -> Dictionary:
	var id_counts = {}
	for diccionario in arr_de_diccionarios:
		if diccionario.has(nombre):
			var id_valor = diccionario[nombre]
			if id_valor in id_counts:
				id_counts[id_valor] += 1
			else:
				id_counts[id_valor] = 1

	var max_count = 0
	var id_mas_frecuente = null

	for id_val in id_counts:
		if id_counts[id_val] > max_count:
			max_count = id_counts[id_val]
			id_mas_frecuente = id_val

	return {"max_count": max_count, "id": id_mas_frecuente}

func _ready() -> void:
	$Vacio.text = ""
	var db = Db.conectar_base()
	var partidas = db.select_rows("partida","id_usuario=%d" % [Db.usuario_id],["id_personaje_usado","id_personaje_enfrentado","id_escenario","victoria","duracion_en_sg"])
	if partidas.size() == 0:
		$Vacio.text = "Juegue partidas para acumular estadisticas"
	else:
		var contador_sg = 0
		var contador_victorias=0
		for i in range(partidas.size()):
			contador_sg+=partidas[i]["duracion_en_sg"]
			if partidas[i]["victoria"]:
				contador_victorias+=1
		var p1_id = obtener_id_mas_frecuente(partidas,"id_personaje_usado")['id']
		var p2_id = obtener_id_mas_frecuente(partidas,"id_personaje_enfrentado")['id']
		var escenario_id = obtener_id_mas_frecuente(partidas,"id_escenario")['id']
		
		var porcentaje :int = (contador_victorias*100)/partidas.size()
		
		
		$VBoxContainer/HBoxContainer/Usado.text = "Personaje favorito: " + Db.conseguir_nombre("personaje",p1_id)
		var sprites_p1 : SpriteFrames = load("res://juego/personajes/assets/animaciones/"+Db.conseguir_nombre("personaje",p1_id)+".tres")
		$VBoxContainer/HBoxContainer/AnimatedSprite2D.sprite_frames = sprites_p1
		$VBoxContainer/HBoxContainer/AnimatedSprite2D.scale = Vector2(1.5,1.5)
		$VBoxContainer/HBoxContainer/AnimatedSprite2D.play("idle") 
		$VBoxContainer/HBoxContainer2/Enfrentado.text = "Personaje mas enfrentado: " + Db.conseguir_nombre("personaje",p2_id)
		var sprites_p2 : SpriteFrames = load("res://juego/personajes/assets/animaciones/"+Db.conseguir_nombre("personaje",p2_id)+".tres")
		
		$VBoxContainer/HBoxContainer2/AnimatedSprite2D.sprite_frames = sprites_p2
		$VBoxContainer/HBoxContainer2/AnimatedSprite2D.scale = Vector2(1.5,1.5)
		
		$VBoxContainer/HBoxContainer2/AnimatedSprite2D.play("idle") 
		
		$VBoxContainer/Escenario.text = "Escenario favorito: " + Db.conseguir_nombre("escenario",escenario_id)
		$VBoxContainer/Tiempo.text = "Tiempo de juego: "+ segundos_a_hms_string(contador_sg)
		$VBoxContainer/Tiempo_promedio.text = "Tiempo promedio de partida: " + segundos_a_hms_string(int(contador_sg/partidas.size()))
		$VBoxContainer/Historial.text = "Victorias - Derrotas : %d - %d" % [contador_victorias,partidas.size()-contador_victorias]
		$VBoxContainer/Porcentaje.text = "Porcentaje de victorias: %d" % [porcentaje] + "%"
		
		
func _on_button_pressed() -> void:
	SceneLoader.load_scene("res://menu/escenas/menus/menu_principal/menu_principal_con_animaciones.tscn")
	
