extends Control

var path_carpeta_fondos_menu : String = "res://menu/assets/fondo_menu/"

func _ready() -> void:
    var fondos := DirAccess.get_files_at(path_carpeta_fondos_menu)
    var fondo_a_usar : String = ".import"
    while fondo_a_usar.ends_with(".import"):
        fondo_a_usar = fondos.get(randi_range(0, fondos.size() - 1))
    print(path_carpeta_fondos_menu + fondo_a_usar)
    var textura_fondo : Texture = load(path_carpeta_fondos_menu + fondo_a_usar)
    $TextureRect.texture = textura_fondo
