@tool
extends EditorScript

# Ruta a la carpeta que contiene tus spritesheets
var input_folder_path = "res://juego/personajes/assets/spritesheets/"
# Ruta donde se guardarán los archivos SpriteFrames generados
var output_folder_path = "res://juego/personajes/assets/animaciones/"

# Ancho de cada frame individual en los spritesheets (en píxeles)
var frame_width = 64
# Alto de cada frame individual en los spritesheets (en píxeles)
var frame_height = 64

# Número de columnas en tus spritesheets
var columns = 24
# Número de filas en tus spritesheets
var rows = 1

# Función principal para crear un archivo SpriteFrames en cada carpeta
func crear_spriteframes_en_carpetas(carpeta_inicial: String) -> void:
	var dir := DirAccess.open(carpeta_inicial)
	
	# Abre la carpeta inicial
	if dir:
		# Inicia la lista de archivos y subcarpetas
		dir.list_dir_begin()  # Ignora navegación (.) y (..), y archivos ocultos
		
		var archivo_o_carpeta = dir.get_next()
		while archivo_o_carpeta != "":

			# Si es una carpeta, crea un recurso SpriteFrames
			if dir.current_is_dir():
				# print("Carpeta encontrada: " + archivo_o_carpeta)
				var carpeta_spritesheet := DirAccess.open(carpeta_inicial + archivo_o_carpeta)
				carpeta_spritesheet.list_dir_begin()
				var nombre_png = carpeta_spritesheet.get_next()
				var textura_spritesheet : Texture = load(carpeta_spritesheet.get_current_dir() + "/" + nombre_png)
				#ImageTexture.create_from_image(\
				#Image.load_from_file(carpeta_inicial + archivo_o_carpeta)
				#)
				
				# Crear el recurso SpriteFrames
				var spriteframes = spritesheet_a_spriteframe_personaje(textura_spritesheet)
				var ruta_spriteframes = output_folder_path + archivo_o_carpeta + ".tres"
				
				# Guardar el recurso SpriteFrames en un archivo
				if ResourceSaver.save(spriteframes, ruta_spriteframes) == OK:
					print("SpriteFrames creado: " + ruta_spriteframes)
				else:
					print("Error: No se pudo guardar el SpriteFrames en " + ruta_spriteframes)
			
			archivo_o_carpeta = dir.get_next()
		
		# Finaliza la lista de archivos
		dir.list_dir_end()
	else:
		print("Error: No se pudo abrir la carpeta " + carpeta_inicial)

func spritesheet_a_spriteframe_personaje(textura_spritesheet : Texture) -> SpriteFrames:
	var animaciones = SpriteFrames.new()
	var frame_actual := 0
	
	# idle
	animaciones.add_animation("idle")
	animaciones.set_animation_loop("idle", true)
	animaciones.set_animation_speed("idle", 10.0)

	for i in range(7):
		var frame := AtlasTexture.new()
		frame.atlas = textura_spritesheet
		var region = Rect2( \
		Vector2(0, 0),
		Vector2(frame_width, frame_height)
		)
		region.position = Vector2(frame_actual * frame_width, 0)
		frame.region = region
		animaciones.add_frame("idle", frame, 1.0, i)
		frame_actual += 1
				

	# ataque_1
	animaciones.add_animation("ataque_1")
	animaciones.set_animation_loop("ataque_1", false)
	animaciones.set_animation_speed("ataque_1", 10.0)

	for i in range(3):
		var frame := AtlasTexture.new()
		frame.atlas = textura_spritesheet
		var region = Rect2( \
		Vector2(0, 0),
		Vector2(frame_width, frame_height)
		)
		region.position = Vector2(frame_actual * frame_width, 0)
		frame.region = region
		animaciones.add_frame("ataque_1", frame, 1.0, i)
		frame_actual += 1
	
	# ataque_2
	animaciones.add_animation("ataque_2")
	animaciones.set_animation_loop("ataque_2", false)
	animaciones.set_animation_speed("ataque_2", 10.0)

	for i in range(3):
		var frame := AtlasTexture.new()
		frame.atlas = textura_spritesheet
		var region = Rect2( \
		Vector2(0, 0),
		Vector2(frame_width, frame_height)
		)
		region.position = Vector2(frame_actual * frame_width, 0)
		frame.region = region
		animaciones.add_frame("ataque_2", frame, 1.0, i)
		frame_actual += 1
	
	# ataque_especial
	animaciones.add_animation("ataque_especial")
	animaciones.set_animation_loop("ataque_especial", false)
	animaciones.set_animation_speed("ataque_especial", 10.0)

	for i in range(7):
		var frame := AtlasTexture.new()
		frame.atlas = textura_spritesheet
		var region = Rect2( \
		Vector2(0, 0),
		Vector2(frame_width, frame_height)
		)
		region.position = Vector2(frame_actual * frame_width, 0)
		frame.region = region
		animaciones.add_frame("ataque_especial", frame, 1.0, i)
		frame_actual += 1

	# esquivar
	animaciones.add_animation("esquivar")
	animaciones.set_animation_loop("esquivar", false)
	animaciones.set_animation_speed("esquivar", 10.0)

	for i in range(4):
		var frame := AtlasTexture.new()
		frame.atlas = textura_spritesheet
		var region = Rect2( \
		Vector2(0, 0),
		Vector2(frame_width, frame_height)
		)
		region.position = Vector2(frame_actual * frame_width, 0)
		frame.region = region
		animaciones.add_frame("esquivar", frame, 1.0, i)
		frame_actual += 1
	
	# bloquear
	animaciones.add_animation("bloquear")
	animaciones.set_animation_loop("bloquear", false)
	animaciones.set_animation_speed("bloquear", 10.0)

	var frame1 := AtlasTexture.new()
	frame1.atlas = textura_spritesheet
	var region1 = Rect2( \
	Vector2(0, 0),
	Vector2(frame_width, frame_height)
		)
	region1.position = Vector2(0, 0)
	frame1.region = region1
	animaciones.add_frame("bloquear", frame1, 1.0, 0)

	var frame2 := AtlasTexture.new()
	frame2.atlas = textura_spritesheet
	var region2 = Rect2( \
	Vector2(0, 0),
	Vector2(frame_width, frame_height)
		)
	region2.position = Vector2(6 * frame_width, 0)
	frame2.region = region2
	animaciones.add_frame("bloquear", frame2, 1.0, 1)

	return animaciones

func _run() -> void:
	crear_spriteframes_en_carpetas(input_folder_path)
