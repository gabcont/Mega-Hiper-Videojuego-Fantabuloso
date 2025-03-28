extends Node

var db
var usuario_id

func _ready():
	db = SQLite.new()
	var db_path = "res://base.db" # Reemplaza con la ruta de tu base de datos
	db.path = db_path
	var success = db.open_db()
	
	
	
	
func conectar_base():
	return db
	
func set_usuario_id(id):
	usuario_id = id
	
func conseguir_id(tabla,nombre):
	var db = conectar_base()
	var registrado = db.select_rows(tabla,"nombre='"+nombre+"'",["id"])
	
	return registrado[0]["id"]
func conseguir_nombre(tabla,id):
	var db = conectar_base()
	var registrado = db.select_rows(tabla,"id=%d" % [id],["nombre"])
	return registrado[0]["nombre"]
	
