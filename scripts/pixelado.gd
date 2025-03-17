extends Sprite2D

func _ready():
    if material is ShaderMaterial:
        # Obtén el tamaño del viewport
        var viewport_rect = get_viewport_rect()
        var viewport_size = viewport_rect.size

        # Establece el valor del uniform "viewport_size" en el shader
        material.set_shader_parameter("viewport_size", viewport_size)

func _process(_delta):
    # Si el tamaño del viewport puede cambiar durante el juego (por ejemplo, al redimensionar la ventana),
    # actualiza el uniform aquí. Si no cambia, puedes dejarlo solo en _ready().
    if material is ShaderMaterial:
        var viewport_rect = get_viewport_rect()
        var viewport_size = viewport_rect.size
        material.set_shader_parameter("viewport_size", viewport_size)