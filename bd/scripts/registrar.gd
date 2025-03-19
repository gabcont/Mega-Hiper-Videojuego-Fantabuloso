extends Button
@onready var statusLabel = get_node("../StatusLabel")
func _ready():
	# Conecta la señal "pressed" del botón a la función "on_button_pressed"
	pressed.connect(on_button_pressed)

func on_button_pressed():
	# Obtiene referencias a los nodos LineEdit
	var line_edit_usuario = get_node("../LineEdit") # Ajusta la ruta si es necesario
	var line_edit_contrasena = get_node("../LineEdit2") # Ajusta la ruta si es necesario
	# Obtiene el texto de los LineEdit
	var usuario = line_edit_usuario.text
	var contrasena = line_edit_contrasena.text
	
	if usuario.length()==0 or contrasena.length()==0:
		statusLabel.text = "Llene todos los campos"
		return
	if usuario.length()<2:
		statusLabel.text = "El username debe ser al menos de 2 caracteres"
	
	if contrasena.length() >= 8:
		registrar(usuario,contrasena)
	else:
		statusLabel.text = "La contraseña debe ser al menos de 8 caracteres"
	
	

	
func registrar(usuario,contrasena):
	var db = Db.conectar_base()
	var registrado = db.select_rows("Usuario","username='"+usuario+"'",["username"])
	if registrado.size()>0:
		statusLabel.text = "Usuario ya registrado"
	else:
		var res = db.insert_row("Usuario",{"username":usuario,"hashed_password":contrasena})
		statusLabel.text =  "Usuario creado con éxito" if res else "Error al crear el usuario"
	
