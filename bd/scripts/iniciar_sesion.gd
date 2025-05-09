extends Control

signal sesion_iniciada

@onready var statusLabel = %StatusLabel

func _ready():
	# Conecta la señal "pressed" del botón a la función "on_button_pressed"
	%IniciarSesionButton.pressed.connect(on_button_pressed)

func on_button_pressed():
	# Obtiene referencias a los nodos LineEdit
	var line_edit_usuario = %CajaTextoUsuario # Ajusta la ruta si es necesario
	var line_edit_contrasena = %CajaTextoContrasena # Ajusta la ruta si es necesario
	# Obtiene el texto de los LineEdit
	var usuario = line_edit_usuario.text
	var contrasena = line_edit_contrasena.text

	
	if usuario.length()==0 or contrasena.length()==0:
		statusLabel.text = "Llene todos los campos"
		return
	iniciar_sesion(usuario,contrasena)
	
func iniciar_sesion(usuario,contrasena):
	var db = Db.conectar_base()
	var registrado = db.select_rows("usuario","nombre_usuario='"+usuario+"'",["id","nombre_usuario","contraseña"])
	if registrado.size()==0:
		statusLabel.text = "Usuario o contraseña incorrectos"
	else:
		
		var resto_de_16 = 16 - (contrasena.length() % 16)
		var texto_formateado = contrasena + " ".repeat(resto_de_16)
		var data = texto_formateado.to_utf8_buffer()
		
		Dotenv.load_("res://.env")
		var key = OS.get_environment("CLAVE_SECRETA").to_utf8_buffer()
		
		var aes = AESContext.new()
		aes.start(AESContext.MODE_ECB_ENCRYPT, key)
		var data_encriptada = aes.update(data)
		
		
		var cadena_encriptada = ""
		
		for i in range(0, data_encriptada.size()):
			cadena_encriptada += str(data_encriptada[i])
			if i < data_encriptada.size() - 1:
				cadena_encriptada += "_"
		
		
		var es_correcto = registrado[0]["contraseña"] == cadena_encriptada
		aes.finish()
		if not es_correcto:
			statusLabel.text = "Usuario o contraseña incorrectos"
		else:
			var usuario_id = db.select_rows("usuario","nombre_usuario='"+usuario+"'",["id"])[0]["id"]
			Db.set_usuario_id(usuario_id)

			sesion_iniciada.emit()
