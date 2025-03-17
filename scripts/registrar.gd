extends Button
@onready var errorLabel = get_node("../StatusLabel")
func _ready():
	# Conecta la señal "pressed" del botón a la función "on_button_pressed"
	pressed.connect(on_button_pressed)

func on_button_pressed():
	# Obtiene referencias a los nodos LineEdit
	var line_edit_usuario = get_node("../TextEdit") # Ajusta la ruta si es necesario
	var line_edit_contrasena = get_node("../TextEdit2") # Ajusta la ruta si es necesario
	# Obtiene el texto de los LineEdit
	var usuario = line_edit_usuario.text
	var contrasena = line_edit_contrasena.text
	
	if contrasena.length() > 6:
		registrar(usuario,contrasena)
	else:
		errorLabel.text = "La conntraseña debe ser al menos de 6 caracteres"
	
	
	# Llama a tu función con los textos
	
func registrar(usuario,contrasena):
	var db = Db.conectar_base()
	var registrado = db.select_rows("Usuario","username='"+usuario+"'",["username"])
	if registrado.size()>0:
		errorLabel.text = "Usuario ya registrado"
	else:
		var res = db.insert_row("Usuario",{"username":usuario,"hashed_password":contrasena})
		errorLabel.text =  "Success" if res else ""
	
