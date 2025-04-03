extends Node

var db
var usuario_id = 5 # Por defecto (para facilidad de desarrollo) abre con mi cuenta

func _ready():
	db = SQLite.new()
	var db_path = "res://base.db" # Reemplaza con la ruta de tu base de datos
	db.path = db_path
	var success = db.open_db()
	if not success:
		print("Base de datos no pudo ser iniciada.")
	
func conectar_base():
	return db
	
func set_usuario_id(id):
	usuario_id = id
	print("Sesion iniciada con usuarioID: %d" % usuario_id)
	
func conseguir_id(tabla,nombre):
	var registrado = db.select_rows(tabla,"nombre='"+nombre+"'",["id"])
	return registrado[0]["id"]

func conseguir_nombre(tabla,id):
	var registrado = db.select_rows(tabla,"id=%d" % [id],["nombre"])
	return registrado[0]["nombre"]
	
func registrar_partida(ganador : int, duracion : int):
	var p1_id = Db.conseguir_id("personaje",ConfigPartida.nombre_personaje_1)
	var p2_id = Db.conseguir_id("personaje",ConfigPartida.nombre_personaje_2)
	var escenario_id = Db.conseguir_id("escenario",ConfigPartida.escenario_seleccionado)
	db.insert_row("partida",{"id_usuario":Db.usuario_id,"id_personaje_usado":p1_id,"id_personaje_enfrentado":p2_id,"victoria":ganador==1,"duracion_en_sg":duracion,"id_escenario":escenario_id})
