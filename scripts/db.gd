extends Node

var db

func _ready():
	db = SQLite.new()
	var db_path = "res://base.db" # Reemplaza con la ruta de tu base de datos
	db.path = db_path
	var success = db.open_db()
	
	
	
func conectar_base():
	return db
		
		
		
	
	
		
